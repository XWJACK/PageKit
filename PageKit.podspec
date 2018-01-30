Pod::Spec.new do |s|
  s.name = "PageKit"
  s.version = "0.2.1"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.summary = "Page Library"
  s.homepage = "https://github.com/XWJACK/PageKit"
  s.author = { "Jack" => "xuwenjiejack@gmail.com" }
  s.source = { :git => "https://github.com/XWJACK/PageKit.git", :tag => s.version }

  s.ios.deployment_target = "8.0"
  
  s.source_files  = ["Sources/*.swift", "Sources/PageKit.h"]
  s.public_header_files = ["Sources/PageKit.h"]

  s.requires_arc = true
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.2' }
end
