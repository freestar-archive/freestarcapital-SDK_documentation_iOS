//
//  ViewController.swift
//  FreestarSwiftSample
//
//  Created by Vdopia Developer on 3/27/20.
//  Copyright © 2020 Freestar. All rights reserved.
//

import UIKit
import FreestarAds

class ViewController: UIViewController {
    
    let loadButton = UIButton(type: .system)
    let showButton = UIButton(type: .system)
    
    let bannerAdContainer = UIView()
    
    var bannerContainerPortraitXPos : NSLayoutConstraint!
    var bannerContainerPortraitYPos : NSLayoutConstraint!
    var bannerContainerLandscapeXPos : NSLayoutConstraint!
    var bannerContainerLandscapeYPos : NSLayoutConstraint!
    
    var smallBanner : FreestarBannerAd?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Freestar Ads"
        
        loadButton.setTitle("Load", for: .normal)
        loadButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        loadButton.addTarget(self,
                             action:#selector(ViewController.loadSelectedAdType),
                             for: .touchUpInside)
        self.view.addSubview(loadButton)
        loadButton.translatesAutoresizingMaskIntoConstraints = false
        loadButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        loadButton.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 20).isActive = true
        
        showButton.setTitle("Show", for: .normal)
        showButton.isEnabled = false
        showButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        showButton.addTarget(self,
                             action:#selector(ViewController.showSelectedAdType),
                             for: .touchUpInside)
        self.view.addSubview(showButton)
        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.leftAnchor.constraint(equalTo: loadButton.rightAnchor, constant: 20).isActive = true
        showButton.topAnchor.constraint(equalTo: loadButton.topAnchor).isActive = true
        
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
    
    @objc func loadSelectedAdType() {
        callSDKLoad("Small Banner")
    }
    
    @objc func showSelectedAdType() {
        let adType = "Small Banner"
        if adType == "Interstitial" {
            showInterstitialAd()
        } else if adType == "Rewarded" {
            showRewardedAd()
        } else if adType == "Banner" {
            showBannerAd()
        } else if adType == "Preroll" {
            showPrerollAd()
        } else if adType == "Small Banner" {
            showSmallBannerAd()
        }
    }
    
    func callSDKLoad(_ adType: String) {
        if adType == "Interstitial" {
            loadInterstitialAd()
        } else if adType == "Rewarded" {
            loadRewardedAd()
        } else if adType == "Banner" {
            loadBannerAd()
        } else if adType == "Preroll" {
            loadPrerollAd()
        } else if adType == "Small Banner" {
            loadSmallBannerAd()
        }
    }

}

extension ViewController {
    func loadInterstitialAd() {
        
    }
    
    func showInterstitialAd() {
        
    }
    
    func loadRewardedAd() {
        
    }
    
    func showRewardedAd() {
        
    }
    
    func loadPrerollAd() {
        
    }
    
    func showPrerollAd() {
        
    }
}

