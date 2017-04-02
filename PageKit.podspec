Pod::Spec.new do |s|

  s.name         = "PageKit"
  s.version      = "0.1.0"
  s.summary      = "XWJACK Page Library"

  s.homepage     = "https://github.com/XWJACK/PageKit"
  s.author       = { "Jack" => "xuwenjiejack@gmail.com" }

  s.ios.deployment_target  = "8.0"

  s.source       = { :git => "https://github.com/XWJACK/PageKit.git", :tag => s.version }

  s.source_files  = ["Sources/*.swift"]
  s.public_header_files = ["Sources/PageKit.h"]

  s.requires_arc = true

end
