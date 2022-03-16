Imversed is a library for [Imversed](https://github.com/imversed/imversed) blockchain-network written in Swift.

- [Communication](#communication)
- [Installation](#installation)
    - [Cocoapods](#cocoapods)
- [Usage](#usage)
    - [Configuration](#configuration)
    - [Wallet](#wallet)
    - [Bank](#bank)
    - [NFT](#nft)
    - [Complex](#complex)
- [License](#license)


## Communication
- If you **found a bug**, open an issue here on GitHub. The more detail the better!
- If you **have a feature request**, open an issue.


## Installation
### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Imversed into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'Imversed', '~> 0.3.0'
```

## Usage
> All examples require `import Imversed` somewhere in the source file.

### Configuration
#### Startup
Basic configuration looks like a following snippet:
```swift
Imversed.configure(
    connection: .init(
        imversed: (host: host, port: 9090),
        tendermint: (host: host, port: 26657)
    ), configuration: .init(
        timeout: 120,   // default 120
        retries: 5      // default 5
    )
)
```

Where `imversed` is host and port for blockchain app running somewhere and `tendermint` almost always differs from `imversed` in only port.

Parameter `configuration` could be omitted, and default values will be used for that.

#### Logging options
Logging level could be modified with:
```swift
Imversed.update(logLevel: LogLevel)
```
There is four levels available: `debug, info, warning, error`

#### Adjust fees calculations
If you need to adjust fees calculations you could update default parameters for gas fee calculation with:
```swift
// example json: [{"operation":"sendCoins","gas":{"price":"0.001","limit":100000}}]
Imversed.update(gasConfiguration: "json")
```
Available operations list:
* `sendCoins` — used for bank transaction with sending coins
* `mintNft` — used for NFT minting new token transaction
* `transferNft` — used for NFT transferring token transaction
* `burn` — used for NFT burn transaction

Default values for all of this operations is `price = 0.001` and `limit = 200_000`

### Wallet
`Wallet` — is a bunch of cryptographic rules and mechanisms that contains functions to work with:
- `Mnemonic` — secret key of user's wallet (you shouldn't send it to anyone)
- `Address` — public part of `mnemonic` used to address some queries and transactions for corresponding wallet (user)

`Mnemonic` key could be generated with:
```swift
let mnemonic: Wallet.Mnemonic = Wallet.generateMnemonic()
```
after that you could obtain an address that correspond to `mnemonic` with:
```swift
let address: Wallet.Address? = mnemonic.address
// or
let address: Wallet.Address = try mnemonic.getAddress()
```
mnemonic key could be restored with an array of words:
```swift
// get a list of Words used to generate mnemonic
let words: [Word] = mnemonic.words
// restore a mnemonic with stored words
let restored: Wallet.Mnemonic = Wallet.Mnemonic(words: words)

// and there is a convinience way to work with words
// a phrase string that contains words separated by space (` `) symbol
let phrase: String = mnemonic.phrase
// restore a mnemonic with phrase
let restored: Wallet.Mnemonic = Wallet.Mnemonic(phrase: phrase)
```

### Bank
#### Balance
Could be queried with:
```swift
Bank.queryBalance(address: "address", denom: "denom", completion: { result in
    print(result)
})
```
or with Mnemonic key:
```swift
Bank.queryBalance(mnemonic: mnemonic, denom: "denom", completion: { result in
    print(result)
})
```

#### Send coins
Before making any transaction you would know how many fees will be charged. For that purpose simulation could be used:
```swift
Bank.simulate(
    sendCoins: .init(
        coins: .init(amount: 1_000, denom: "denom"),
        owner: "owner",
        recipient: "recipient"
    ),
    with: mnemonic,
    feeDenom: "denom",
    completion: { result in
        print(result)
    }
)
```
The `result` contains `Imversed.Fee` object with gas price and limit after simulation process

After you know how many fees would be charged you could process transaction as follows:
```swift
Bank.transaction(
    sendCoins: .init(
        coins: .init(amount: 1_000, denom: "denom"),
        owner: "owner",
        recipient: "recipient"
    ),
    with: mnemonic,
    fees: fees,
    completion: { result in
        print(result)
    }
)
```

### NFT
#### Queries
Certain NFT could be queried with:
```swift
NFT.queryToken(id: "NFT identifier", denom: "denom", completion: { result in
    print(result)
})
```

A list of user's NFTs:
```swift
NFT.queryTokens(address: "address", denom: "denom", skip: 0, limit: 30, completion: { result in
    print(result)
})
```
> `skip` and `limit` is a paging parameters

Another functions to get NFTs:
```swift
NFT.queryLastTokens(skip:limit:denom:completion:)
```
> For querying last tokens minted in blockchain

```swift
NFT.queryTokenIds(address:denom:skip:limit:completion:)
```
> For getting NFT ids of certain user wallet `address`

```swift
NFT.queryTokens(by:denom:completion:)
```
> For getting NFTs by list of ids

#### Transactions
Transaction for mint NFT and simulation for fees calculation
```swift
NFT.simulate(
    mint: .init(token: token),
    with: mnemonic,
    feeDenom: "denom",
    completion: { result in
        switch result {
            case .success(let fees):
                print(fees)

            case .failure(let error):
                print(error)
        }
    }
)

NFT.transaction(
    mint: .init(token: token),
    with: mnemonic,
    fees: fees,
    completion: { result in
        print(result)
    }
)
```

NFT could be burned in blockchain with following transaction and simulation for fees calculation:
```swift
NFT.simulate(
    burn: .init(token: token),
    with: mnemonic,
    feeDenom: "denom",
    completion: { result in
        switch result {
        case .success(let fees):
            print(fees)
            
        case .failure(let error):
            print(error)
        }
    }
)

NFT.burn(
    request: .init(token: token),
    with: mnemonic,
    feeDenom: "denom",
    completion: { result in
        print(result)
    }
)
```

### Complex
There is a complex transactions contains a few actions, for example: someone want to buy NFT for coins from another user. For that purpose you could use following functions:
```swift
Complex.prepare(
    bidTransaction: .init(
        transfer: .init(token: token, recipient: "recipient"),
        sendCoins: .init(coins: .init(amount: 100, denom: "denom"), owner: "owner", recipient: "recipient")
    ),
    with: mnemonic,
    fees: fees,
    completion: { result in
        switch result {
            case .success(let partialBidData):
                print(partialBidData)

            case .failure(let error):
                print(error)
        }
    }
)
```
> First of all we need to prepare partial bid `Data` from buyer

Then we need to proceed that partial bid `Data` by seller
> `Data` should be passed to the seller somehow

```swift
Complex.proceed(
    partial: partialBidData,
    with: mnemonic,
    completion: { result in
        print(result)
    }
)
```
> Under the hood that function will just sign bid request that contains NFT transfer and send coins actions by the NFT's owner


## License
Imversed iOS client is released under the MIT license. See LICENSE for details.
