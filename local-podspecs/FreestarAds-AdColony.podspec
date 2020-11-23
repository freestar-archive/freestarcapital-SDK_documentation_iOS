# Author: Lev Trubov
# © 2018 Vdopia, Inc.

# FreestarAds-SDK

Pod::Spec.new do |spec|
  spec.name                = 'FreestarAds-AdColony'
  spec.version             = ENV['FSA_POD_VERSION']
  spec.author              = 'Freestar'
  spec.license             = { :type => 'Apache2.0', :file => 'LICENCE.md' }
  spec.homepage            = 'http://www.freestar.com'
  spec.summary             = 'The Freestar AdColony adapter'
  spec.platform            = :ios, '9.0'
  spec.vendored_libraries = 'SDK/libFreestarAds-AdColony.a'
  spec.dependency 'FreestarAds', '~> 3.2'
  spec.dependency 'AdColony', '~> 4.4'

  spec.source            = {
      :git => "https://gitlab.com/freestar/freestar-ios-binaries.git",
      :tag => ENV['FSA_SOURCE']
  }

  # AdColony pod handles this
  # spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  # spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
