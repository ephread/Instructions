#
# Be sure to run `pod lib lint Instructions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Instructions"
  s.version          = "0.1.1"
  s.summary          = "Easily add customizable coach marks into you iOS project."

# This description is used to generate tags and improve search results.
  s.homepage         = "https://github.com/ephread/Instructions"
  s.license          = 'MIT'
  s.author           = { "Frédéric Maquin" => "fred@ephread.com" }
  s.source           = { :git => "https://github.com/ephread/Instructions.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Instructions', 'Source/*.swift'
  s.resources = ["Source/*.xcassets"]
end
