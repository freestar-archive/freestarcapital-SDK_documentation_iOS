# Author: Lev Trubov
# © 2018 Vdopia, Inc.

# FreestarAds-SDK

Pod::Spec.new do |spec|
  spec.name                = 'FreestarAds-Vungle'
  spec.version             = ENV['FSA_POD_VERSION']
  spec.author              = 'Freestar'
  spec.license             = { :type => 'Apache2.0', :file => 'LICENCE.md' }
  spec.homepage            = 'http://www.freestar.com'
  spec.summary             = 'The Freestar Vungle adapter'
  spec.platform            = :ios, '9.0'

  spec.vendored_libraries = 'SDK/libFreestarAds-Vungle.a'
  spec.dependency 'FreestarAds', '~> 3.2'
  spec.dependency 'VungleSDK-iOS', '~> 6.8'

  spec.source            = {
      :git => "https://gitlab.com/freestar/freestar-ios-binaries.git",
      :tag => ENV['FSA_SOURCE']
  }
end
