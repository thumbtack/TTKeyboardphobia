Pod::Spec.new do |s|
  s.name             = "TTKeyboardphobia"
  s.version          = "0.1.0"
  s.summary          = "Simple keyboard avoiding for iOS."
  s.description      = <<-DESC
                        TTKeyboardphobia is a simple and straightforward to use library for keyboard avoidance on iOS.

                        * No subclasses
                        * Simple API.
                        * Supports accessory views.
                        * Supports alignment with a UIView container.
                       DESC
  s.homepage         = "https://github.com/thumbtack/TTKeyboardphobia"
  s.license          = 'BSD'
  s.author           = { "Ian Leitch" => "ileitch@thumbtack.com" }
  s.source           = { :git => "https://github.com/thumbtack/TTKeyboardphobia.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'TTKeyboardphobia' => ['Pod/Assets/*.png']
  }

  s.frameworks = 'UIKit'
end
