# Author: Lev Trubov
# © 2018 Vdopia, Inc.

# FreestarAds-SDK

Pod::Spec.new do |spec|
    spec.name                = 'FreestarAds-Googleadmob'
    spec.version             = '2.3.0.1'
    spec.author              = 'Freestar'
    spec.license             = { :type => 'Apache2.0', :file => 'LICENCE.md' }
    spec.homepage            = 'http://www.freestar.com'
    spec.summary             = 'The Freestar Google Admob adapter'
    spec.platform            = :ios, '9.0'

    spec.vendored_libraries = 'SDK/libFreestarAds-Googleadmob.a'
    spec.dependency 'FreestarAds', '~> 3.5'
    spec.dependency 'Google-Mobile-Ads-SDK', '~> 7.67'

    spec.resources = 'SDK/Assets/*.xib'

    spec.source            = {
    :git => "https://gitlab.com/freestar/freestar-ios-binaries.git",
    }

    spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
