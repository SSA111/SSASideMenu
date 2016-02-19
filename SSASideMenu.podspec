Pod::Spec.new do |s|
  s.name         = "SSASideMenu"
  s.version      = "1.0.1"
  s.summary      = "iOS Slide View based on iQON, Feedly, Google+, Ameba iPhone app."
  s.homepage     = "https://github.com/mbalex99/SSASideMenu.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Maximilian Alexander" => "mbalex99@gmail.com" }
  s.social_media_url   = "https://twitter.com/dekatotoro"
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/mbalex99/SSASideMenu.git", :tag => "1.0.0" }
  s.source_files  = "SSASideMenu/*"
  s.requires_arc = true
end