//
//  ThumbnailAdViewController.swift
//  FreestarSwiftSample
//
//  Created by Carlos Alcala on 11/08/22.
//

import UIKit
import FreestarAds

class ThumbnailAdViewController: AdViewController {

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

        self.enablePartnerSelection = false
    }

    // MARK: - controlling UI

    @objc override func updateShowButton() {
        showButton.isEnabled = thumbnailAdReady
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
}
