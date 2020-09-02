//
//  ViewController.swift
//  FreestarSwiftSample
//
//  Copyright © 2020 Freestar. All rights reserved.
//

import UIKit
import FreestarAds

class BannerAdViewController: AdViewController {
    
    let bannerAdContainer = UIView()
    
    var bannerContainerPortraitXPos : NSLayoutConstraint?
    var bannerContainerPortraitYPos : NSLayoutConstraint?
    var bannerContainerLandscapeXPos : NSLayoutConstraint?
    var bannerContainerLandscapeYPos : NSLayoutConstraint?
    
    var smallBanner: FreestarBannerAd?
    var largeBanner: FreestarBannerAd?
    
    var smallBannerAdReady = false {
        didSet {
            updateShowButton()
        }
    }
    
    var largeBannerAdReady = false {
        didSet {
            updateShowButton()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupBannerContainer()
        self.enablePartnerSelection = false
    }
    
    func setupBannerContainer() {
        bannerAdContainer.backgroundColor = .lightGray;
        self.view.addSubview(bannerAdContainer)
        bannerAdContainer.translatesAutoresizingMaskIntoConstraints = false
        
        bannerContainerPortraitXPos = bannerAdContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        bannerContainerLandscapeXPos = bannerAdContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        bannerContainerPortraitYPos = bannerAdContainer.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 20)
        bannerContainerLandscapeYPos = bannerAdContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        
        bannerContainerPortraitXPos?.isActive = true
        bannerContainerPortraitYPos?.isActive = true
        
        bannerAdContainer.widthAnchor.constraint(equalToConstant: 330).isActive = true
        bannerAdContainer.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    override func loadChosenAd() {
        if concreteAdTypeSelector.selectedSegmentIndex == 0 {
            loadSmallBannerAd()
        } else {
            loadLargeBannerAd()
        }
    }
    
    override func showChosenAd() {
        if concreteAdTypeSelector.selectedSegmentIndex == 0 {
            showSmallBannerAd()
        } else {
            showLargeBannerAd()
        }
    }

    
    override func selectedAdType() -> FreestarAdType {
        return concreteAdTypeSelector.selectedSegmentIndex == 0 ? .SmallBanner : .LargeBanner
    }
    
    override func concreteAdTypes() -> [String] {
        return ["Small Banner", "Large Banner"]
    }
    
    // MARK: - controlling UI
    
    @objc override func updateShowButton() {
        showButton.isEnabled =
            (self.concreteAdTypeSelector.selectedSegmentIndex == 0 && smallBannerAdReady) ||
            (self.concreteAdTypeSelector.selectedSegmentIndex == 1 && largeBannerAdReady)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_ context: UIViewControllerTransitionCoordinatorContext) in
            let orient = UIApplication.shared.statusBarOrientation
            if orient == .portrait {
                self.bannerContainerLandscapeXPos?.isActive = false
                self.bannerContainerLandscapeYPos?.isActive = false
                self.bannerContainerPortraitXPos?.isActive = true
                self.bannerContainerPortraitYPos?.isActive = true
            } else {
                self.bannerContainerPortraitXPos?.isActive = false
                self.bannerContainerPortraitYPos?.isActive = false
                self.bannerContainerLandscapeXPos?.isActive = true
                self.bannerContainerLandscapeYPos?.isActive = true
            }
        }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
    }
}

extension BannerAdViewController : FreestarBannerAdDelegate {
    func closeExistingBanners() {
        self.smallBanner?.removeFromSuperview()
        self.smallBanner = nil
        self.largeBanner?.removeFromSuperview()
        self.largeBanner = nil
    }
    
    func loadLargeBannerAd() {
        closeExistingBanners()
        self.largeBannerAdReady = false
        largeBanner = FreestarBannerAd(delegate: self, andSize: .banner300x250)
        
        largeBanner?.loadPlacement(placementField.text)
    }
    
    func loadSmallBannerAd() {
        closeExistingBanners()
        self.smallBannerAdReady = false
        smallBanner = FreestarBannerAd(delegate: self, andSize: .banner320x50)
        smallBanner?.loadPlacement(placementField.text)
    }
    
    func showLargeBannerAd() {
        self.largeBannerAdReady = false
        largeBanner?.center = CGPoint(x: bannerAdContainer.bounds.midX, y: bannerAdContainer.bounds.midY)
        bannerAdContainer.addSubview(largeBanner!)
    }
    
    func showSmallBannerAd() {
        self.smallBannerAdReady = false
        smallBanner?.center = CGPoint(x: bannerAdContainer.bounds.midX, y: bannerAdContainer.bounds.midY)
        bannerAdContainer.addSubview(smallBanner!)
    }
    
    // - Banner Delegate
    
    func freestarBannerLoaded(_ ad: FreestarBannerAd) {
        if ad == smallBanner {
            self.smallBannerAdReady = true
        } else {
            self.largeBannerAdReady = true
        }
    }
    
    func freestarBannerFailed(_ ad: FreestarBannerAd, because reason: FreestarNoAdReason) {
        if ad == smallBanner {
            self.smallBannerAdReady = false
        } else {
            self.largeBannerAdReady = false
        }
    }
    
    func freestarBannerShown(_ ad: FreestarBannerAd) {
        
    }
    
    func freestarBannerClicked(_ ad: FreestarBannerAd) {
        
    }
    
    func freestarBannerClosed(_ ad: FreestarBannerAd) {
        if ad == smallBanner {
            self.smallBannerAdReady = false
        } else {
            self.largeBannerAdReady = false
        }
    }
    
}
