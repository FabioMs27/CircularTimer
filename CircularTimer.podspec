#
#  Be sure to run `pod spec lint CircularTimer.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "CircularTimer"
  spec.version      = "0.0.1"
  spec.summary      = "A CocoaPods library written in Swift"

  spec.description  = "A Circular Timer that counts down time in both foreground and background with a circular progression animation and fully customizable."

  spec.homepage     = "https://github.com/FabioMs27/CircularTimer"


  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.source       = { :git => "https://github.com/FabioMs27/CircleTimer.git", :tag => "#{spec.version}" }

  spec.author       = { "FabioMs27" => "fabio.ms27@hotmail.com" }

  spec.ios.deployment_target = "13.5"
  spec.swift_version = "5.3"

  spec.source_files  = "CircularTimer/**/*.{h,m,swift}"

end