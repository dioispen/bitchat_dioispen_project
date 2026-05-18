platform :ios, '13.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'bitchat.xcodeproj'

flutter_application_path = 'flutter_module'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'bitchat_iOS' do
  install_all_flutter_pods(flutter_application_path)
end

target 'bitchatTests_iOS' do
  inherit! :search_paths
end

post_install do |installer|
  flutter_post_install(installer)
end
