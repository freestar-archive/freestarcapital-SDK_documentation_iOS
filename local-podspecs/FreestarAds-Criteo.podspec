
#  FreestarAds-Amazon.podspec
#  test_App
#
#  Created by Lev Trubov on 3/15/19.
#  Copyright © 2019 Freestar. All rights reserved.

Pod::Spec.new do |spec|
  spec.name                = 'FreestarAds-Criteo'
  spec.version             = ENV['FSA_POD_VERSION']
  spec.author              = 'Freestar'
  spec.license             = { :type => 'Apache2.0', :file => 'LICENCE.md' }
  spec.homepage            = 'http://www.freestar.com'
  spec.summary             = 'The Freestar Amazon adapter'
  spec.platform            = :ios, '9.0'

  spec.vendored_libraries = 'SDK/libFreestarAds-Criteo.a'
  spec.dependency 'FreestarAds', '~> 3.2'
  spec.dependency 'CriteoPublisherSdk', '~> 3.2.0'

  spec.source            = {
    :git => "https://gitlab.com/freestar/freestar-ios-binaries.git",
    :tag => ENV['FSA_SOURCE']
  }
end
