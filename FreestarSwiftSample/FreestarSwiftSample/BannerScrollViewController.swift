//
//  BannerScrollViewController.swift
//  FreestarSwiftSample
//
//  Created by Lev Trubov on 9/8/20.
//  Copyright © 2020 Freestar. All rights reserved.
//

import UIKit
import FreestarAds

class BannerScrollViewController: AdViewController {
    
    let bannerAdContainer = UIScrollView()
    
    var bannerContainerPortraitXPos : NSLayoutConstraint?
    var bannerContainerPortraitYPos : NSLayoutConstraint?
    var bannerContainerLandscapeXPos : NSLayoutConstraint?
    var bannerContainerLandscapeYPos : NSLayoutConstraint?
    
    var smallBanners = [FreestarBannerAd?]()
    var largeBanners = [FreestarBannerAd?]()
    
    var smallBannersLoaded = 0
    var largeBannersLoaded = 0
    
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
        
        bannerAdContainer.contentSize = CGSize(width: 700, height: 300)
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

extension BannerScrollViewController : FreestarBannerAdDelegate {
    func closeExistingBanners() {
        self.smallBanners.forEach { $0?.removeFromSuperview() }
        self.largeBanners.forEach { $0?.removeFromSuperview() }
        
        self.smallBanners.removeAll()
        self.largeBanners.removeAll()
    }
    
    func loadLargeBannerAd() {
        closeExistingBanners()
        self.largeBannerAdReady = false
        
        largeBanners.append(contentsOf: [
            FreestarBannerAd(delegate: self, andSize: .banner300x250),
            FreestarBannerAd(delegate: self, andSize: .banner300x250)
        ])
        
        largeBanners.forEach { $0?.loadPlacement(placementField.text) }
    }
    
    func loadSmallBannerAd() {
        closeExistingBanners()
        self.smallBannerAdReady = false
        
        smallBanners.append(contentsOf: [
            FreestarBannerAd(delegate: self, andSize: .banner320x50),
            FreestarBannerAd(delegate: self, andSize: .banner320x50)
        ])
    }
    
    func showLargeBannerAd() {
        self.largeBannerAdReady = false
        
        var ind = 0.0
        largeBanners.forEach {
            let xCoord = CGFloat(165.0 + ind*(300.0 + 20.0))
            $0?.center = CGPoint(x: xCoord, y: bannerAdContainer.bounds.midY)
            bannerAdContainer.addSubview($0!)
            ind += 1.0
        }
    }
    
    func showSmallBannerAd() {
        self.smallBannerAdReady = false
        
        var ind = 0.0
        smallBanners.forEach {
            let xCoord = CGFloat(165.0 + ind*(320.0 + 20.0))
            $0?.center = CGPoint(x: xCoord, y: bannerAdContainer.bounds.midY)
            bannerAdContainer.addSubview($0!)
            ind += 1.0
        }
    }
    
    // - Banner Delegate
    
    func freestarBannerLoaded(_ ad: FreestarBannerAd) {
        if smallBanners.contains(ad as FreestarBannerAd) {
            smallBannersLoaded += 1
            if smallBannersLoaded == smallBanners.count {
                self.smallBannerAdReady = true
            }
        } else {
            largeBannersLoaded += 1
            if largeBannersLoaded == largeBanners.count {
                self.largeBannerAdReady = true
            }
        }
    }
    
    func freestarBannerFailed(_ ad: FreestarBannerAd, because reason: FreestarNoAdReason) {
        if smallBanners.contains(ad as FreestarBannerAd) {
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
        if smallBanners.contains(ad as FreestarBannerAd) {
            self.smallBannerAdReady = false
        } else {
            self.largeBannerAdReady = false
        }
    }
}
