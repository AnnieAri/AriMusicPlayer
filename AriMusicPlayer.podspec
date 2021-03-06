#
# Be sure to run `pod lib lint AriMusicPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AriMusicPlayer'
  s.version          = '0.2.0'
  s.summary          = 'AriMusicPlayer. 面向协议,使用工厂模式封装两个播放器'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
AriMusicPlayer. 面向协议,使用工厂模式封装两个播放器
1.AVPlayer
2.FreeStreamer
                       DESC

  s.homepage         = 'https://github.com/AnnieAri/AriMusicPlayer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ari' => '18354295998@sina.cn' }
  s.source           = { :git => 'https://github.com/AnnieAri/AriMusicPlayer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AriMusicPlayer/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AriMusicPlayer' => ['AriMusicPlayer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'FreeStreamer'
end
