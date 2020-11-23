# Author: Lev Trubov
# © 2018 Vdopia, Inc.

# FreestarAds-SDK

Pod::Spec.new do |spec|
  spec.name                = 'FreestarAds-Google'
  spec.version             = ENV['FSA_POD_VERSION']
  spec.author              = 'Freestar'
  spec.license             = { :type => 'Apache2.0', :file => 'LICENCE.md' }
  spec.homepage            = 'http://www.freestar.com'
  spec.summary             = 'The Freestar Google adapter'
  spec.platform            = :ios, '10.0'

  spec.vendored_libraries = 'SDK/libFreestarAds-Google.a'
  spec.dependency 'FreestarAds', '~> 3.5'
  spec.dependency 'GoogleAds-IMA-iOS-SDK', '~> 3.13'

  spec.source            = {
      :git => "https://gitlab.com/freestar/freestar-ios-binaries.git",
      :tag => ENV['FSA_SOURCE']
  }

  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

end
