# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'

target 'Balphyo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Balphyo
	pod 'SnapKit'
	pod 'Tabman'
	pod 'Then'
	pod 'Kingfisher'
	pod 'Charts'
	pod 'SCLAlertView'
	pod 'Alamofire', '~> 5.4.4'
	pod 'KakaoSDKAuth'
  	pod 'KakaoSDKUser'
  	pod 'KakaoSDKCommon'
	pod 'Firebase/Core'
	pod 'Firebase/Messaging'
	pod 'SwiftKeychainWrapper'
	pod 'Socket.IO-Client-Swift'
	pod 'Starscream'
	pod 'StompClientLib'
end
post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end