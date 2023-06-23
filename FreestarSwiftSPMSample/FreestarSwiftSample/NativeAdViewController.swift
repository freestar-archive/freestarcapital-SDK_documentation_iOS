//
//  ViewController.swift
//  FreestarSwiftSample
//
//  Copyright © 2020 Freestar. All rights reserved.
//

import UIKit
import FreestarAds

class NativeAdViewController: AdViewController {
    
    let nativeAdContainer = UIView()
    
    var smallNative: FreestarNativeAd?
    var largeNative: FreestarNativeAd?
    
    var smallNativeAdReady = false {
        didSet {
            updateShowButton()
        }
    }
    
    var largeNativeAdReady = false {
        didSet {
            updateShowButton()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupNativeContainer()
        self.enablePartnerSelection = false
    }
    
    func setupNativeContainer() {
        nativeAdContainer.backgroundColor = .lightGray;
        self.view.addSubview(nativeAdContainer)
        nativeAdContainer.translatesAutoresizingMaskIntoConstraints = false
        nativeAdContainer.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(375)
            make.height.equalTo(325)
        }
    }
    
    func setupConstraints(_ native: FreestarNativeAd) {
        guard native.superview != nil else {
            return
        }

        if native === self.smallNative {
            native.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                make.width.equalTo(nativeAdContainer.frame.width)
                make.height.equalTo(100)
            }
        } else {
            native.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                make.width.equalTo(nativeAdContainer.frame.width)
                make.height.equalTo(nativeAdContainer.frame.height)
            }
        }
    }
    
    override func loadChosenAd() {
        if concreteAdTypeSelector.selectedSegmentIndex == 0 {
            loadSmallNativeAd()
        } else {
            loadLargeNativeAd()
        }
    }
    
    override func showChosenAd() {
        if concreteAdTypeSelector.selectedSegmentIndex == 0 {
            showSmallNativeAd()
        } else {
            showLargeNativeAd()
        }
    }
    
    override func selectedAdType() -> FreestarAdType {
        return concreteAdTypeSelector.selectedSegmentIndex == 0 ? .SmallBanner : .LargeBanner
    }
    
    override func concreteAdTypes() -> [String] {
        return ["Small Native", "Large Native"]
    }
    
    // MARK: - controlling UI
    
    @objc override func updateShowButton() {
        showButton.isEnabled =
            (self.concreteAdTypeSelector.selectedSegmentIndex == 0 && smallNativeAdReady) ||
            (self.concreteAdTypeSelector.selectedSegmentIndex == 1 && largeNativeAdReady)
    }
}

extension NativeAdViewController : FreestarNativeAdDelegate {
    func closeExistingNatives() {
        self.smallNative?.removeFromSuperview()
        self.smallNative = nil
        self.largeNative?.removeFromSuperview()
        self.largeNative = nil
    }
    
    func loadLargeNativeAd() {
        closeExistingNatives()
        self.largeNativeAdReady = false
        largeNative = FreestarNativeAd(delegate: self, andSize: .medium)
        largeNative?.loadPlacement(placementField.text)
        largeNative?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func loadSmallNativeAd() {
        closeExistingNatives()
        self.smallNativeAdReady = false
        smallNative = FreestarNativeAd(delegate: self, andSize: .small)
        smallNative?.loadPlacement(placementField.text)
        smallNative?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func showLargeNativeAd() {
        self.largeNativeAdReady = false
        nativeAdContainer.addSubview(largeNative!)
        setupConstraints(largeNative!)
    }
    
    func showSmallNativeAd() {
        self.smallNativeAdReady = false
        nativeAdContainer.addSubview(smallNative!)
        setupConstraints(smallNative!)
    }
    
    // - Native Delegate
    
    func freestarNativeLoaded(_ ad: FreestarNativeAd) {
        if ad == smallNative {
            self.smallNativeAdReady = true
        } else {
            self.largeNativeAdReady = true
        }
        setupConstraints(ad)
        guard let responseInfo = ad.responseInfo else {
            return
        }
        print(responseInfo)
    }
    
    func freestarNativeFailed(_ ad: FreestarNativeAd, because reason: FreestarNoAdReason) {
        if ad == smallNative {
            self.smallNativeAdReady = false
        } else {
            self.largeNativeAdReady = false
        }
    }
    
    func freestarNativeShown(_ ad: FreestarNativeAd) {
        
    }
    
    func freestarNativeClicked(_ ad: FreestarNativeAd) {
        
    }
    
    func freestarNativeClosed(_ ad: FreestarNativeAd) {
        if ad == smallNative {
            self.smallNativeAdReady = false
        } else {
            self.largeNativeAdReady = false
        }
    }
    
}
