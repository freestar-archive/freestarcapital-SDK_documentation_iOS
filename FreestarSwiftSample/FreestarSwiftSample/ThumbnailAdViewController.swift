//
//  ThumbnailAdViewController.swift
//  FreestarSwiftSample
//
//  Created by Carlos Alcala on 11/08/22.
//

import UIKit
import FreestarAds

class ThumbnailAdViewController: AdViewController {

    let showBlackButton = UIButton(type: .system)
    let showFullScreenButton = UIButton(type: .system)

    var thumbnailAd : FreestarThumbnailAd?

    var thumbnailAdReady = false {
        didSet {
            updateShowButton()
        }
    }

    // MARK: - data for common elements

    override func selectedAdType() -> FreestarAdType {
        return .Thumbnail
    }

    override func concreteAdTypes() -> [String] {
        return ["Thumbnail"]
    }

    override func loadChosenAd() {
        loadThumbnailAd()
    }

    override func showChosenAd() {
        showThumbnailAd()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupConfig()
        setupBlackButtons()
        setupFullScreen()

        self.enablePartnerSelection = false
    }

    func setupConfig() {
        //FreestarThumbnailAd Configurations
        FreestarThumbnailAd.setWhitelistBundleIdentifiers(["io.freestar.ads.FreestarSwiftSample"])
        FreestarThumbnailAd.setBlacklistViewControllers(["BlackViewController","FullscreenAdViewControllerPush","FullscreenAdViewController"])
        FreestarThumbnailAd.setGravity(FreestarThumbnailAdGravity.TopLeft)
        FreestarThumbnailAd.setXMargin(100)
        FreestarThumbnailAd.setYMargin(500)
    }

    // MARK: - controlling UI

    @objc override func updateShowButton() {
        showButton.isEnabled = thumbnailAdReady
    }

    func setupBlackButtons() {
        showBlackButton.setTitle("Show Black", for: .normal)
        showBlackButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        showBlackButton.addTarget(self,
                             action:#selector(showBlackVC),
                             for: .touchUpInside)
        self.view.addSubview(showBlackButton)
        showBlackButton.translatesAutoresizingMaskIntoConstraints = false
        showBlackButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 100).isActive = true
        showBlackButton.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 10).isActive = true
    }

    func setupFullScreen() {
        showFullScreenButton.setTitle("Show FullScreen", for: .normal)
        showFullScreenButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        showFullScreenButton.addTarget(self,
                             action:#selector(showFullVC),
                             for: .touchUpInside)
        self.view.addSubview(showFullScreenButton)
        showFullScreenButton.translatesAutoresizingMaskIntoConstraints = false
        showFullScreenButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 100).isActive = true
        showFullScreenButton.topAnchor.constraint(equalTo: showBlackButton.bottomAnchor, constant: 30).isActive = true
    }

    @objc
    func showBlackVC() {
        //PUSH
        navigationController?.pushViewController(BlackViewController(), animated: true)
    }

    @objc
    func showFullVC() {
        //PUSH
        navigationController?.pushViewController(FullscreenAdViewControllerPush(), animated: true)
    }
}

private extension ThumbnailAdViewController {
    func loadThumbnailAd() {
        self.thumbnailAd = FreestarThumbnailAd(delegate: self)
        self.thumbnailAd?.load()
    }

    func showThumbnailAd() {
        thumbnailAd?.show()
    }
}

extension ThumbnailAdViewController : FreestarThumbnailAdDelegate {
    func onThumbnailLoaded(_ ad: FreestarThumbnailAd) {
        self.thumbnailAdReady = true
    }

    func onThumbnailFailed(_ ad: FreestarThumbnailAd, because reason: FreestarNoAdReason) {
        self.thumbnailAdReady = false
    }

    func onThumbnailShown(_ ad: FreestarThumbnailAd) {
    }

    func onThumbnailClicked(_ ad: FreestarThumbnailAd) {
    }

    func onThumbnailClosed(_ ad: FreestarThumbnailAd) {
        self.thumbnailAdReady = false
    }

    func onThumbnailDismissed(_ ad: FreestarThumbnailAd) {
        self.thumbnailAdReady = false
    }
}
