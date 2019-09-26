# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'SwyftSdk' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for swyft-app-ios-sdk
  
  # MBProgressHUD
  #pod 'MBProgressHUD'
  # Moya
  pod 'Moya', '~> 12.0.1'
  #pod 'EVReflection/MoyaXML', '~> 5.10.1'
  #XML Mapper
  pod 'XMLMapper', '~> 1.5.3'
  
  # CryptoSwift
  pod 'CryptoSwift', '~> 1.0.0'
  
  # Firebase
  pod 'Firebase/Core', '~> 6.5.0'
  pod 'Firebase/Firestore', '~> 6.5.0'
  pod 'Firebase/Auth', '~> 6.5.0'
  
  #JVFloatLabeledTextField
  pod 'JVFloatLabeledTextField', '~> 1.2.1'
  
  #SwiftTryCatch
  pod 'SwiftTryCatch', '~> 0.0.1'
  
  #SipHash
  pod 'SipHash', '~> 1.2'
  
  target 'SwyftSdkTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  project = installer.pods_project
  
  # prevent frameworks which they are already linked with a module from being linked with the main target again
  installer.aggregate_targets.each do |target|
    project.build_configurations.each do |build_configuration|
      configFilePath = target.xcconfig_path(build_configuration.name)
      configFile = File.read(configFilePath)
      configFile = configFile.gsub(/-framework "Firebase" /, '')
      configFile = configFile.gsub(/-framework "FirebaseCore" /, '')
      configFile = configFile.gsub(/-framework "FirebaseFirestore" /, '')
      File.open(configFilePath, 'w') { |file| file << configFile }
    end
  end
end
