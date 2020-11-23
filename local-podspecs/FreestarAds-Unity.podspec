
#  FreestarAds-Unity.podspec
#  test_App
#
#  Created by Lev Trubov on 1/29/18.
#  Copyright © 2018 Freestar. All rights reserved.

Pod::Spec.new do |spec|
  spec.name                = 'FreestarAds-Unity'
  spec.version             = ENV['FSA_POD_VERSION']
  spec.author              = 'Freestar'
  spec.license             = { :type => 'Apache2.0', :file => 'LICENCE.md' }
  spec.homepage            = 'http://www.freestar.com'
  spec.summary             = 'The Freestar Unity adapter'
  spec.platform            = :ios, '9.0'

  spec.vendored_libraries = 'SDK/libFreestarAds-Unity.a'
  spec.dependency 'FreestarAds', '~> 3.2'
  spec.dependency 'UnityAds', '~> 3.5'

  spec.source            = {
      :git => "https://gitlab.com/freestar/freestar-ios-binaries.git",
      :tag => ENV['FSA_SOURCE']
  }

  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
