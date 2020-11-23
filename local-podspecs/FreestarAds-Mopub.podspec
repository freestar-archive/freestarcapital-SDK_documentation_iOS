# Author: Lev Trubov
# © 2018 Vdopia, Inc.

# FreestarAds-SDK

Pod::Spec.new do |spec|
  spec.name                = 'FreestarAds-Mopub'
  spec.version             = ENV['FSA_POD_VERSION']
  spec.author              = 'Freestar'
  spec.license             = { :type => 'Apache2.0', :file => 'LICENCE.md' }
  spec.homepage            = 'http://www.freestar.com'
  spec.summary             = 'The Freestar Mopub adapter'
  spec.platform            = :ios, '10.0'

  spec.vendored_libraries = 'SDK/libFreestarAds-Mopub.a'
  spec.dependency 'FreestarAds', '~> 3.2'
  spec.dependency 'mopub-ios-sdk', '~> 5.14'

  spec.source            = {
      :git => "https://gitlab.com/freestar/freestar-ios-binaries.git",
      :tag => ENV['FSA_SOURCE']
  }
end
