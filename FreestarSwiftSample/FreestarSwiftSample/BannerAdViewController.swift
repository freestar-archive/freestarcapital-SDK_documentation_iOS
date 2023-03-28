//
//  ViewController.swift
//  FreestarSwiftSample
//
//  Copyright © 2020 Freestar. All rights reserved.
//

import UIKit
import CoreGraphics
import FreestarAds
import SnapKit

class BannerAdViewController: AdViewController {
    
    @IBOutlet var container: UIView?
    
    lazy var smallBanner: FreestarBannerAd = {
        let banner = FreestarBannerAd(delegate: self, andSize: .banner320x50)
        banner.adaptiveBannerWidth = calculateAdaptiveViewWidth()
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
    lazy var largeBanner: FreestarBannerAd = {
        let banner = FreestarBannerAd(delegate: self, andSize: .banner300x250)
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
    
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
        enablePartnerSelection = false
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
            smallBannerAdReady = false
            showBanner(banner: smallBanner)
        } else {
            largeBannerAdReady = false
            showBanner(banner: largeBanner)
        }
        //        let webView: WKWebView = smallBanner.findFirstWkWebView()
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
        (concreteAdTypeSelector.selectedSegmentIndex == 0 && smallBannerAdReady) ||
        (concreteAdTypeSelector.selectedSegmentIndex == 1 && largeBannerAdReady)
    }
}

extension BannerAdViewController : FreestarBannerAdDelegate {
    func loadLargeBannerAd() {
        largeBannerAdReady = false
        largeBanner.loadPlacement(nil)
    }
    
    func loadSmallBannerAd() {
        smallBannerAdReady = false
        smallBanner.loadPlacement(placementField.text)
    }
    
    func showBanner(banner: FreestarBannerAd) {
        guard let container = container else {
            return
        }
        if (banner.superview == nil) {
            container.subviews.forEach({ $0.removeFromSuperview() })
            container.addSubview(banner)
        }
        setupConstraints(banner)
    }
    
    func setupConstraints(_ banner: FreestarBannerAd) {
        guard banner.superview != nil else {
            return
        }

        if banner === self.smallBanner {
            banner.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                make.width.equalTo(calculateAdaptiveViewWidth())
                make.height.equalTo(banner.frame.height)
            }
        } else {
            banner.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                make.width.equalTo(banner.frame.width)
                make.height.equalTo(banner.frame.height)
            }
        }
    }
    
    // - Banner Delegate
    
    func didUpdateBanner(_ ad: FreestarBannerAd, with size: CGSize) {
        setupConstraints(ad)
    }
    
    func freestarBannerLoaded(_ ad: FreestarBannerAd) {
        if ad == smallBanner {
            smallBannerAdReady = true
        } else {
            largeBannerAdReady = true
        }
        setupConstraints(ad)
    }
    
    func freestarBannerFailed(_ ad: FreestarBannerAd, because reason: FreestarNoAdReason) {
        if ad == smallBanner {
            smallBannerAdReady = false
        } else {
            largeBannerAdReady = false
        }
    }
    
    func freestarBannerShown(_ ad: FreestarBannerAd) {
        
    }
    
    func freestarBannerClicked(_ ad: FreestarBannerAd) {
        
    }
    
    func freestarBannerClosed(_ ad: FreestarBannerAd) {
        if ad == smallBanner {
            smallBannerAdReady = false
        } else {
            largeBannerAdReady = false
        }
    }
    
}
