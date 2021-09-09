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
    
    var bannerContainerXPos : NSLayoutConstraint?
    var bannerContainerYPos : NSLayoutConstraint?
    var bannerContainerWidth : NSLayoutConstraint?
    var bannerContainerHeight : NSLayoutConstraint?
    var adaptiveBannerContainerWidth : NSLayoutConstraint?
    
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
    }
    
    func disableAllConstraints() {
        bannerContainerXPos?.isActive = false
        bannerContainerYPos?.isActive = false
        bannerContainerWidth?.isActive = false
        bannerContainerHeight?.isActive = false
        adaptiveBannerContainerWidth?.isActive = false
    }
    
    func updateBannerContainerContraints(size: CGSize, isAdaptive: Bool) {
        disableAllConstraints()
        
        bannerContainerXPos = bannerAdContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        bannerContainerYPos = bannerAdContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        
        bannerContainerXPos?.isActive = true
        bannerContainerYPos?.isActive = true

        if (isAdaptive == true) {
            adaptiveBannerContainerWidth = bannerAdContainer.widthAnchor.constraint(equalToConstant: calculateAdaptiveViewWidth())
            adaptiveBannerContainerWidth?.isActive = true
        } else {
            bannerContainerWidth = bannerAdContainer.widthAnchor.constraint(equalToConstant: size.width)
            bannerContainerWidth?.isActive = true
        }
        bannerContainerHeight = bannerAdContainer.heightAnchor.constraint(equalToConstant: size.height)
        bannerContainerHeight?.isActive = true
    }
    
    func calculateAdaptiveViewWidth() -> CGFloat {
        let frame = { () -> CGRect in
          // Here safe area is taken into account, hence the view frame is used
          // after the view has been laid out.
          if #available(iOS 11.0, *) {
            return view.frame.inset(by: view.safeAreaInsets)
          } else {
            return view.frame
          }
        }()
        return frame.size.width
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
        updateBannerContainerContraints(size:ad.frame.size, isAdaptive: ad.isAdaptive)
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
