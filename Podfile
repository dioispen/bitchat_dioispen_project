platform :ios, '13.0'
platform :osx, '13.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'bitchat.xcodeproj'

flutter_application_path = 'flutter_module'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'bitchat_iOS' do
  use_frameworks!
  install_all_flutter_pods(flutter_application_path)
end

target 'bitchat_macOS' do
  use_frameworks!
  if Dir.exist?(File.join(flutter_application_path, 'macos'))
    flutter_install_all_macos_pods(File.join(flutter_application_path, 'macos'))
  else
    install_all_flutter_pods(flutter_application_path)
  end
end

target 'bitchatTests_iOS' do
  inherit! :search_paths
end

target 'bitchatTests_macOS' do
  inherit! :search_paths
end

post_install do |installer|
  flutter_post_install(installer)
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] ||= '13.0'
    end
  end
end
