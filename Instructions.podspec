Pod::Spec.new do |s|
  s.name             = "Instructions"
  s.version          = "0.4.1"
  s.summary          = "Create walkthroughs and guided tours (with coach marks) in a simple way, using Swift."
  s.homepage         = "https://github.com/ephread/Instructions"
  s.license          = 'MIT'
  s.author           = { "Frédéric Maquin" => "fred@ephread.com" }
  s.source           = { :git => "https://github.com/ephread/Instructions.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Instructions', 'Source/*.swift'
  s.resources = ["Source/*.xcassets"]
end
