//
//  FreestarSwiftUIBanner.swift
//  FreestarSwiftUISample
//
//  Created by Dean Chang on 8/15/22.
//

import Foundation

import SwiftUI
import FreestarAds

struct CustomSwiftUIBanner: UIViewRepresentable {
    
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
    
    private func widthFromSize(_ size: FreestarBannerAdSize) -> Int {
        if (size ==  FreestarBannerAdSize.banner300x250) {
            return 300
        } else {
            return 320
        }
    }
    
    private func heightFromSize(_ size: FreestarBannerAdSize) -> Int {
        if (size ==  FreestarBannerAdSize.banner320x50) {
            return 50
        } else {
            return 250
        }
    }

    func makeUIView(context: Context) -> FreestarBannerAd {
        let banner = FreestarBannerAd(delegate: context.coordinator, andSize: size)
        banner.delegate = context.coordinator
        return banner
    }

    func updateUIView(_ uiView: FreestarBannerAd, context: Context) {
        uiView.loadPlacement(placementId)
    }

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
