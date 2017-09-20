target ‘ARMaze’

use_frameworks!
pod 'Firebase'
pod 'Firebase/Database'
pod 'SnapKit', '~> 3.2.0'
pod 'PopupDialog', '~> 0.5'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
