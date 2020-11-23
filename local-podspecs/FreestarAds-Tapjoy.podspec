
#  FreestarAds-Tapjoy.podspec
#  test_App
#
#  Created by Lev Trubov on 1/29/18.
#  Copyright © 2018 Freestar. All rights reserved.


Pod::Spec.new do |spec|
  spec.name                = 'FreestarAds-Tapjoy'
  spec.version             = ENV['FSA_POD_VERSION']
  spec.author              = 'Freestar'
  spec.license             = { :type => 'Apache2.0', :file => 'LICENCE.md' }
  spec.homepage            = 'http://www.freestar.com'
  spec.summary             = 'The Freestar Tapjoy adapter'
  spec.platform            = :ios, '9.0'

  spec.vendored_libraries = 'SDK/libFreestarAds-Tapjoy.a'
  spec.dependency 'FreestarAds', '~> 3.2'
  spec.dependency 'TapjoySDK', '~> 12.4.0'

  spec.source            = {
      :git => "https://gitlab.com/freestar/freestar-ios-binaries.git",
      :tag => ENV['FSA_SOURCE']
  }
end
