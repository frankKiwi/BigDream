#
#  Be sure to run `pod spec lint BigDream.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

 

  s.name         = "BigDream"
  s.version      = "0.0.1"
  s.summary      = "A short description of BigDream."

 

  s.homepage     = "https://github.com/frankKiwi/BigDream.git"
 

  s.license      = "MIT"
 

  s.author             = { "fanrenFRank" => "1778907544@qq.com" }
 

  s.platform     = :ios, "8.0"

 

  s.source       = { :git => "https://github.com/frankKiwi/BigDream.git", :tag => "#{s.version}" }



   s.source_files = '**/*.{h,m}' 
s.frameworks  = "UIKit", "Foundation"
s.dependency "JPush", "~> 3.0.9"
s.requires_arc = true

end