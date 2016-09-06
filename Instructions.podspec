Pod::Spec.new do |spec|
  spec.cocoapods_version = '>= 0.39'

  spec.name             = "Instructions"
  spec.version          = "0.5.0"
  spec.summary          = "Create walkthroughs and guided tours (with coach marks) in a simple way, using Swift."
  spec.homepage         = "https://github.com/ephread/Instructions"
  spec.license          = 'MIT'
  spec.author           = { "Frédéric Maquin" => "fred@ephread.com" }
  spec.source           = { :git => "https://github.com/ephread/Instructions.git", :tag => spec.version.to_s }

  spec.platform     = :ios, '8.0'
  spec.requires_arc = true

  spec.default_subspec = 'Core'

  spec.subspec 'AppExtensions' do |subspec|
    subspec.source_files = 'Instructions', 'Sources/**/*.swift'
    subspec.resources = ["Sources/**/*.xcassets"]
    subspec.pod_target_xcconfig = {'OTHER_SWIFT_FLAGS' => '-DINSTRUCTIONS_APP_EXTENSIONS'}
  end

  spec.subspec 'Core' do |subspec|
    subspec.source_files = 'Instructions', 'Sources/**/*.swift'
    subspec.resources = ["Sources/**/*.xcassets"]
  end
end
