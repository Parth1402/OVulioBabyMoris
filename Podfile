# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Ovulio Baby' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Ovulio Baby


  pod 'Hero'
  pod 'Device', :git => 'https://github.com/Ekhoo/Device.git', :commit =>'f2f796b86201cd96271417b99dfd41eb338db395'  #pod "Device", '~> 3.2.1'
  pod 'IQKeyboardManagerSwift'
  pod 'Pageboy', '~> 4.0'
  pod 'GLScratchCard'
  pod 'SPConfetti'
  pod 'SPAlert'
  pod 'SwiftyStoreKit'
  pod 'ReachabilitySwift'
  pod 'Blurberry'
  pod 'Siren'
  pod 'Malert'
  pod 'SwiftyStarRatingView'
  pod 'TrueTime'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Messaging'
  pod 'GlowingView'
  pod 'ViewAnimator'
  pod 'FSPagerView'
  pod 'AppsFlyerFramework'
  pod 'ScreenShield'
  pod 'SwiftyRSA'
  pod 'AlignedCollectionViewFlowLayout'
  pod 'Koloda'



end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
    end
  end
end
