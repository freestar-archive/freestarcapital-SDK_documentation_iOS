//
//  FreestarSwiftUIBanner.swift
//  FreestarSwiftUISample
//
//  Created by Dean Chang on 8/15/22.
//

import Foundation

import SwiftUI
import FreestarAds

final class CustomSwiftUIBanner: UIViewRepresentable {
    
    var placementId: String?
    var size: FreestarBannerAdSize
    var internalBanner: FreestarBannerAd?
    
    public init(placementId: String?, size: FreestarBannerAdSize) {
        self.placementId = placementId
        self.size = size
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    func makeUIView(context: Context) -> FreestarBannerAd {
        internalBanner = FreestarBannerAd(delegate: context.coordinator, andSize: size)
        internalBanner!.delegate = context.coordinator
        internalBanner!.loadPlacement(placementId)
        return internalBanner!
    }

    func updateUIView(_ uiView: FreestarBannerAd, context: Context) {}

    class Coordinator: NSObject, FreestarBannerAdDelegate {
        
// MARK: FreestarBannerAdDelegate
        
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
