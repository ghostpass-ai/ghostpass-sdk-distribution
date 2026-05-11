Pod::Spec.new do |s|
  s.name         = 'GoPassSDK'
  s.version      = '1.0.1'
  s.summary      = 'GoPass SDK for iOS'
  s.homepage     = 'https://github.com/ghostpass-ai/ghostpass-sdk-distribution'
  s.license      = { :type => 'Commercial', :text => 'Copyright ghostpass-ai. All rights reserved.' }
  s.author       = { 'GhostPassSDK' => 'sdk-support@ghostpass.ai' }

  s.platform     = :ios, '15.0'
  s.swift_versions = ['5.9']

  s.source = {
    :http => 'https://github.com/ghostpass-ai/ghostpass-sdk-distribution/releases/download/1.0.1/GoPassSDK.xcframework.zip'
  }

  s.vendored_frameworks = 'GoPassSDK.xcframework'
end
