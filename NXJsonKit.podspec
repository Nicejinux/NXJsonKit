#
# Be sure to run `pod lib lint NXJsonKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NXJsonKit'
  s.version          = '0.3.0'
  s.summary          = 'NXJsonKit is simple and easy JSON to Data model mapper.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
NXJsonKit can set JSON dictionary values to object type values or user defined data model easily.
                       DESC

  s.homepage         = 'https://github.com/nicejinux/NXJsonKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'nicejinux' => 'nicejinux@gmail.com' }
  s.source           = { :git => 'https://github.com/nicejinux/NXJsonKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'NXJsonKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NXJsonKit' => ['NXJsonKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
