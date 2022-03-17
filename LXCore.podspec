Pod::Spec.new do |s|
  s.name             = 'LXCore'
  s.version          = '0.1.0'
  s.summary          = 'Some description'
  s.swift_versions   = '4.0' 
 
  s.description      = 'Detailed description'

  s.homepage         = 'https://github.com/artakgev/LXCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Artak Gevorgyan' => 'artakmail@gmail.com' }
  s.source           = { :git => 'https://github.com/artakgev/LXCore.git', :tag => "#{s.version}" }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'LXCore/**/*.{swift,h}'
 
end
