Pod::Spec.new do |s|
  s.name             = "TTKeyboardphobia"
  s.version          = "0.1.0"
  s.summary          = "A short description of TTKeyboardphobia."
  s.description      = <<-DESC
                       An optional longer description of TTKeyboardphobia

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
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
