//
//  ViewController.swift
//  FreestarSwiftSample
//
//  Copyright © 2020 Freestar. All rights reserved.
//

import UIKit
import FreestarAds

class BannerAdViewController: AdViewController {
    
    @IBOutlet var container: UIView?
    private var currentSize: CGSize = CGSizeMake(300, 250)
    private var mrecSize: CGSize = CGSizeMake(300, 250)
        
    lazy var smallBanner: FreestarBannerAd = {
        let banner = FreestarBannerAd(delegate: self, andSize: .banner320x50)
        banner.adaptiveBannerWidth = calculateAdaptiveViewWidth()
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
    lazy var largeBanner: FreestarBannerAd = {
        let banner = FreestarBannerAd(delegate: self, andSize: .banner300x250)
        banner.adaptiveBannerWidth = calculateAdaptiveViewWidth()
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
    
    var smallBannerConstraints: [NSLayoutConstraint] {
        return [ smallBanner.centerXAnchor.constraint(equalTo: container!.centerXAnchor),
                 smallBanner.centerYAnchor.constraint(equalTo: container!.centerYAnchor),
                 smallBanner.widthAnchor.constraint(equalToConstant: smallBanner.frame.width),
                 smallBanner.heightAnchor.constraint(equalToConstant: smallBanner.frame.height)]
    }
    
    var largeBannerConstraints : [NSLayoutConstraint] {
        return [ largeBanner.centerXAnchor.constraint(equalTo: container!.centerXAnchor),
                 largeBanner.centerYAnchor.constraint(equalTo: container!.centerYAnchor),
                 largeBanner.widthAnchor.constraint(equalToConstant: largeBanner.frame.width),
                 largeBanner.heightAnchor.constraint(equalToConstant: largeBanner.frame.height)]
    }
    
    var largeNativeConstraints : [NSLayoutConstraint] {
        return [ largeBanner.centerXAnchor.constraint(equalTo: container!.centerXAnchor),
                 largeBanner.centerYAnchor.constraint(equalTo: container!.centerYAnchor),
                 largeBanner.widthAnchor.constraint(lessThanOrEqualToConstant: container!.frame.width),
                 largeBanner.heightAnchor.constraint(lessThanOrEqualToConstant: container!.frame.height)]
    }
    
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
    
    private func currentSizeEqualToMrecSize() -> Bool {
        return CGSizeEqualToSize(currentSize, mrecSize)
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
    
    func didUpdateBanner(_ ad: FreestarBannerAd, with size: CGSize) {
        currentSize = size
        var newFrame = CGRectZero
        newFrame.size = size
        self.container!.frame = newFrame
        if (ad == largeBanner) {
            largeBanner.frame = newFrame
        }
        setAnchorConstraints(ad)        
    }
    
    func loadLargeBannerAd() {
        largeBannerAdReady = false
        largeBanner.loadPlacement(placementField.text)
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
                
        setAnchorConstraints(banner)
    }
    
    func setAnchorConstraints(_ banner: FreestarBannerAd) {
        if (banner.superview == nil) {
            return
        }
        if (banner == smallBanner) {
            NSLayoutConstraint.activate(smallBannerConstraints)
        } else {
            NSLayoutConstraint.deactivate(largeBannerConstraints)
            NSLayoutConstraint.deactivate(largeNativeConstraints)
            if (currentSizeEqualToMrecSize()) {
                NSLayoutConstraint.activate(largeBannerConstraints)
            } else {
                largeBanner.frame.origin = CGPointZero
                NSLayoutConstraint.activate(largeNativeConstraints)
            }
        }
        view.layoutIfNeeded()
    }
    
    // - Banner Delegate
    
    func freestarBannerLoaded(_ ad: FreestarBannerAd) {
        if ad == smallBanner {
            smallBannerAdReady = true
        } else {
            largeBannerAdReady = true
        }
        setAnchorConstraints(ad)
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
