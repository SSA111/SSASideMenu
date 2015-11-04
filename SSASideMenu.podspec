Pod::Spec.new do |s|
  s.name        = "SSASideMenu"
  s.version     = "1.0.0"
  s.summary     = "SSASideMenu is a reimplementation of romaonthego/RESideMenu in Swift. A iOS 7/8 style side menu with parallax effect."
  s.homepage    = "https://github.com/SSA111/SSASideMenu"
  s.license     = { :type => "MIT" }
  s.author    = "Sebastian Andersen"

  s.requires_arc = true
  s.ios.deployment_target = "8.0"
  s.source   = { :git => "https://github.com/SSA111/SSASideMenu.git", :tag => s.version.to_s}
  s.source_files = "SSASideMenu/*.swift"
end
