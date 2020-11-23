# Author: Lev Trubov
# © 2018 Vdopia, Inc.

# FreestarAds-SDK

Pod::Spec.new do |spec|
  spec.name                = 'FreestarAds'
  spec.version             = '3.5.0.1'
  spec.author              = 'Freestar'
  spec.license             = { :type => 'Apache2.0', :file => 'LICENCE.md' }
  spec.homepage            = 'http://www.freestar.com'
  spec.summary             = 'Freestar Ads Mediation system'
  spec.platform            = :ios, '9.0'

  spec.public_header_files = 'SDK/FreestarAds.framework/**/*.h'
  spec.source_files        = 'SDK/FreestarAds.framework/**/*.h'
  spec.vendored_frameworks = 'SDK/FreestarAds.framework', 'SDK/FreestarAdsCore.framework'

  spec.source            = {
      :git => "https://gitlab.com/freestar/freestar-ios-binaries.git"
  }

  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
