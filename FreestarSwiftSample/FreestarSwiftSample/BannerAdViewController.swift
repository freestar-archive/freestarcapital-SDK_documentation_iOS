//
//  ViewController.swift
//  FreestarSwiftSample
//
//  Created by Vdopia Developer on 3/27/20.
//  Copyright © 2020 Freestar. All rights reserved.
//

import UIKit
import FreestarAds

class BannerAdViewController: AdViewController {
    
    let bannerAdContainer = UIView()
    
    var bannerContainerPortraitXPos : NSLayoutConstraint!
    var bannerContainerPortraitYPos : NSLayoutConstraint!
    var bannerContainerLandscapeXPos : NSLayoutConstraint!
    var bannerContainerLandscapeYPos : NSLayoutConstraint!
    
    var smallBanner : FreestarBannerAd?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupBannerContainer()
        
    }
    
    func setupBannerContainer() {
        bannerAdContainer.backgroundColor = .lightGray;
        self.view.addSubview(bannerAdContainer)
        bannerAdContainer.translatesAutoresizingMaskIntoConstraints = false
        
        bannerContainerPortraitXPos = bannerAdContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        bannerContainerLandscapeXPos = bannerAdContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        bannerContainerPortraitYPos = bannerAdContainer.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 20)
        bannerContainerLandscapeYPos = bannerAdContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        
        bannerContainerPortraitXPos.isActive = true
        bannerContainerPortraitYPos.isActive = true
        
        bannerAdContainer.widthAnchor.constraint(equalToConstant: 330).isActive = true
        bannerAdContainer.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    override func loadChosenAd() {
        if concreteAdTypeSelector.selectedSegmentIndex == 0 {
            loadSmallBannerAd()
        } else {
            loadBannerAd()
        }
    }
    
    override func showChosenAd() {
        if concreteAdTypeSelector.selectedSegmentIndex == 0 {
            showSmallBannerAd()
        } else {
            showBannerAd()
        }
    }

    
    override func selectedAdType() -> FreestarAdType {
        return concreteAdTypeSelector.selectedSegmentIndex == 0 ? .SmallBanner : .LargeBanner
    }
    
    override func concreteAdTypes() -> [String] {
        return ["Small Banner", "Large Banner"]
    }
    
    // MARK: - Orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_ context: UIViewControllerTransitionCoordinatorContext) in
            let orient = UIApplication.shared.statusBarOrientation
            if orient == .portrait {
                self.bannerContainerLandscapeXPos.isActive = false
                self.bannerContainerLandscapeYPos.isActive = false
                self.bannerContainerPortraitXPos.isActive = true
                self.bannerContainerPortraitYPos.isActive = true
            } else {
                self.bannerContainerPortraitXPos.isActive = false
                self.bannerContainerPortraitYPos.isActive = false
                self.bannerContainerLandscapeXPos.isActive = true
                self.bannerContainerLandscapeYPos.isActive = true
            }
        }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
    }
}

extension BannerAdViewController : FreestarBannerAdDelegate {
    
    
    func loadBannerAd() {
        
    }
    
    func loadSmallBannerAd() {
        smallBanner?.removeFromSuperview()
        smallBanner = FreestarBannerAd(delegate: self, andSize: .banner320x50)
        smallBanner?.loadPlacement(nil)
    }
    
    func showBannerAd() {
        
    }
    
    func showSmallBannerAd() {
        loadButton.isEnabled = true
        showButton.isEnabled = false
        smallBanner?.center = CGPoint(x: bannerAdContainer.bounds.midX, y: bannerAdContainer.bounds.midY)
        bannerAdContainer.addSubview(smallBanner!)
    }
    
    // - Banner Delegate
    
    func freestarBannerLoaded(_ ad: FreestarBannerAd) {
        showButton.isEnabled = true
    }
    
    func freestarBannerFailed(_ ad: FreestarBannerAd, because reason: FreestarNoAdReason) {
        
    }
    
    func freestarBannerShown(_ ad: FreestarBannerAd) {
        
    }
    
    func freestarBannerClicked(_ ad: FreestarBannerAd) {
        
    }
    
    func freestarBannerClosed(_ ad: FreestarBannerAd) {
        showButton.isEnabled = false
    }
    
}
