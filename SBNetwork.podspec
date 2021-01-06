#
# Be sure to run `pod lib lint SBNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SBNetwork'
  s.version          = '0.3.0'
  s.summary          = 'A short description of SBNetwork.'
  s.swift_versions   = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      =  "Network service"

  s.homepage         = 'https://github.com/sangbeomLee/SBNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.summary          = "help to handle for image cache"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sangbeomLee' => 'wing951@naver.com' }
  s.source           = { :git => 'https://github.com/sangbeomLee/SBNetwork.git', :tag => s.version.to_s }
  s.description      = "help to handle for image cache"

  s.ios.deployment_target = '12.0'

  s.source_files = 'Core/**/*'
  
  # s.resource_bundles = {
  #   'SBNetwork' => ['SBNetwork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
