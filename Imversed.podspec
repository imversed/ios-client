Pod::Spec.new do |spec|
  spec.name = "Imversed"
  spec.summary = spec.name + " iOS Swift client for Imversed blockchain."
  spec.version = "0.3.0"
  
  spec.source = { :git => 'https://github.com/imversed/ios-client.git', :tag => spec.version }
  
  spec.source_files = "Sources/**/*.{swift}"
  spec.license = { :type => "MIT", :file => "LICENSE" }
  spec.author = { "Imversed" => "ios@imversed.com" }
  spec.homepage = "https://www.imversed.com/"
  
  spec.platform = :ios
  spec.ios.deployment_target = '13.0'
  
  spec.dependency 'gRPC-Swift', '~> 1.0.0'
  spec.dependency 'gRPC-Swift-Plugins', '~> 1.0.0'
  spec.dependency 'HDWalletKit', '~> 0.3.0'
end
