project 'TriMeter.xcodeproj'

# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TriMeter' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # ignore all warnings from all pods
  inhibit_all_warnings!

  # Pods for TriMeter
  pod 'IBAnimatable'
  pod 'Reusable'
  pod 'IQKeyboardManager'
  pod 'FRDStravaClient'
  pod 'MBProgressHUD'
  pod 'SwiftGen'
  pod 'Kingfisher'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'DateToolsSwift'
  pod 'Device'
  pod 'InAppSettingsKit', :git => 'https://github.com/Bramnouwen/InAppSettingsKit.git'
  pod 'SugarRecord'
  pod 'SCLAlertView',:git => 'https://github.com/vikmeup/SCLAlertView-Swift.git'
  pod 'Whisper'

  pod 'PromiseKit'
  pod 'PromiseKit/MapKit'
  pod 'PromiseKit/CoreLocation'
  pod 'PromiseKit/WatchConnectivity'

  pod 'Fabric'
  pod 'Crashlytics'

  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'

  pod 'FBSDKLoginKit'
  pod 'FBSDKCoreKit'

  pod 'OneSignal', '>= 2.5.2', '< 3.0'

  target 'TriMeterTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TriMeterUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'OneSignalNotificationServiceExtension' do
  use_frameworks!
  pod 'OneSignal', '>= 2.5.2', '< 3.0'
end