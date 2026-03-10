Pod::Spec.new do |s|
  s.name         = 'GoPassSDK'
  s.version      = '0.1.1'
  s.summary      = 'GoPass SDK for iOS'
  s.homepage     = 'https://github.com/ghostpass-ai/ghostpass-sdk-distribution'
  s.license      = { :type => 'Commercial', :text => 'Copyright ghostpass-ai. All rights reserved.' }
  s.author       = { 'GhostPassSDK' => 'sdk-support@ghostpass.ai' }

  s.platform     = :ios, '15.0'
  s.swift_versions = ['5.9']

  s.source = {
    :http => 'https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/0.1.1/GoPassSDK.xcframework.zip'
  }

  s.vendored_frameworks = 'GoPassSDK.xcframework'

  s.dependency 'Firebase/Auth', '>= 10.0', '< 13.0'
  s.dependency 'Firebase/Database', '>= 10.0', '< 13.0'

  s.frameworks = 'CoreTelephony', 'WebKit'
end
