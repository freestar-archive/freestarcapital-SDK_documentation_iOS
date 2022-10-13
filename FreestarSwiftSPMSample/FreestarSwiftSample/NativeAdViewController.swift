//
//  ViewController.swift
//  FreestarSwiftSample
//
//  Copyright © 2020 Freestar. All rights reserved.
//

import UIKit
import FreestarAds

class NativeAdViewController: AdViewController {
    
    let NativeAdContainer = UIView()
    
    var NativeContainerPortraitXPos : NSLayoutConstraint?
    var NativeContainerPortraitYPos : NSLayoutConstraint?
    var NativeContainerLandscapeXPos : NSLayoutConstraint?
    var NativeContainerLandscapeYPos : NSLayoutConstraint?
    
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
        NativeAdContainer.backgroundColor = .lightGray;
        self.view.addSubview(NativeAdContainer)
        NativeAdContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NativeContainerPortraitXPos = NativeAdContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        NativeContainerLandscapeXPos = NativeAdContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        NativeContainerPortraitYPos = NativeAdContainer.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 20)
        NativeContainerLandscapeYPos = NativeAdContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        
        NativeContainerPortraitXPos?.isActive = true
        NativeContainerPortraitYPos?.isActive = true
        
        NativeAdContainer.widthAnchor.constraint(equalToConstant: 330).isActive = true
        NativeAdContainer.heightAnchor.constraint(equalToConstant: 300).isActive = true
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_ context: UIViewControllerTransitionCoordinatorContext) in
            let orient = UIApplication.shared.statusBarOrientation
            if orient == .portrait {
                self.NativeContainerLandscapeXPos?.isActive = false
                self.NativeContainerLandscapeYPos?.isActive = false
                self.NativeContainerPortraitXPos?.isActive = true
                self.NativeContainerPortraitYPos?.isActive = true
            } else {
                self.NativeContainerPortraitXPos?.isActive = false
                self.NativeContainerPortraitYPos?.isActive = false
                self.NativeContainerLandscapeXPos?.isActive = true
                self.NativeContainerLandscapeYPos?.isActive = true
            }
        }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
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
    }
    
    func loadSmallNativeAd() {
        closeExistingNatives()
        self.smallNativeAdReady = false
        smallNative = FreestarNativeAd(delegate: self, andSize: .small)
        smallNative?.loadPlacement(placementField.text)
    }
    
    func showLargeNativeAd() {
        self.largeNativeAdReady = false
        largeNative?.center = CGPoint(x: NativeAdContainer.bounds.midX, y: NativeAdContainer.bounds.midY)
        NativeAdContainer.addSubview(largeNative!)
    }
    
    func showSmallNativeAd() {
        self.smallNativeAdReady = false
        smallNative?.center = CGPoint(x: NativeAdContainer.bounds.midX, y: NativeAdContainer.bounds.midY)
        NativeAdContainer.addSubview(smallNative!)
    }
    
    // - Native Delegate
    
    func freestarNativeLoaded(_ ad: FreestarNativeAd) {
        if ad == smallNative {
            self.smallNativeAdReady = true
        } else {
            self.largeNativeAdReady = true
        }
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
