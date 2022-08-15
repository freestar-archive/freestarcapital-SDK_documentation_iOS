//
//  FreestarSwiftUIBanner.swift
//  FreestarSwiftUISample
//
//  Created by Dean Chang on 8/15/22.
//

import Foundation

import SwiftUI
import FreestarAds

final class FreestarSwiftUIBanner: UIViewRepresentable {
    
    var placementId: String = "banner_p1"

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    func makeUIView(context: Context) -> FreestarBannerAd {
        let adView = FreestarBannerAd(delegate: context.coordinator, andSize: FreestarBannerAdSize.banner320x50)
        adView.loadPlacement(placementId)
        return adView
    }

    func updateUIView(_ uiView: FreestarBannerAd, context: Context) {}

    class Coordinator: NSObject, FreestarBannerAdDelegate {
        func freestarBannerLoaded(_ ad: FreestarBannerAd) {
            print("\(#function)")
        }
        
        func freestarBannerFailed(_ ad: FreestarBannerAd, because reason: FreestarNoAdReason) {
            print("\(#function): \(reason)")
        }
        
        func freestarBannerShown(_ ad: FreestarBannerAd) {
            print("\(#function)")
        }
        
        func freestarBannerClicked(_ ad: FreestarBannerAd) {
            print("\(#function)")
        }
        
        func freestarBannerClosed(_ ad: FreestarBannerAd) {
            print("\(#function)")
        }
    }
}
