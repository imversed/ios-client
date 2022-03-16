//
//  TxListener+Waiting.swift
//  Imversed
//
//  Created by Ilya S. on 15.02.2022.
//

import Foundation

extension TxListener {
    
    private static let queue = DispatchQueue(
        label: "TxListener+Waiting", qos: .background, attributes: .concurrent
    )
    
    struct Waiting {
        let txHash: String
        let deadline: Date
        let completion: ((Result<Void, Error>) -> Void)?
        
        init(
            txHash: String,
            timeout: TimeInterval = 30,
            completion: @escaping (Result<Void, Error>) -> Void
        ) {
            self.txHash = txHash
            self.deadline = Date().addingTimeInterval(timeout)
            self.completion = completion
        }
    }
    
    private static var waitings: [Waiting] = []
    private static var timer: Timer?
    
    static func append(waiting: Waiting) {
        if self.waitings.isEmpty {
            self.subscribe()
            self.startDeadlineTimer()
        }
        
        self.waitings.append(waiting)
    }
    
    static func resolve(txHash: String) {
        guard let waiting = self.remove(txHash: txHash) else {
            return
        }
        waiting.completion?(.success(()))
    }
    
    static func resolve(txHash: String, error: Error) {
        guard let waiting = self.remove(txHash: txHash) else {
            return
        }
        waiting.completion?(.failure(error))
    }
    
    @discardableResult
    private static func remove(txHash: String) -> Waiting? {
        guard let foundIndex = self.waitings.firstIndex(where: { $0.txHash == txHash }) else {
            return nil
        }
        let waiting = self.waitings.remove(at: foundIndex)
        
        if self.waitings.isEmpty {
            self.unsubscribe()
            self.stopDeadlineTimer()
        }
        
        return waiting
    }
    
}

// MARK: - Deadline timer

private extension TxListener {
    
    static func startDeadlineTimer() {
        self.queue.async {
            if self.timer?.isValid ?? false {
                return
            }
            
            let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
                self.checkExpired()
            })
            self.timer = timer
            
            let currentRunLoop = RunLoop.current
            currentRunLoop.add(timer, forMode: .common)
            currentRunLoop.run()
        }
    }
    
    static func stopDeadlineTimer() {
        self.queue.sync {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    static func checkExpired() {
        let now = Date()
        let expiredTxHashes: [String] = self.waitings
            .filter({ $0.deadline <= now })
            .map({ $0.txHash })
        
        expiredTxHashes.forEach({
            if let waiting = self.remove(txHash: $0), let completion = waiting.completion {
                Tx.query(txHash: waiting.txHash, completion: completion)
            }
        })
    }
    
}
