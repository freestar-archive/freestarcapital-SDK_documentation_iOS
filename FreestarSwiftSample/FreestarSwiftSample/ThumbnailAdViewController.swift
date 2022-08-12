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

    // MARK: - controlling UI

    @objc override func updateShowButton() {
        showButton.isEnabled = thumbnailAdReady
    }
}

extension ThumbnailAdViewController : FreestarThumbnailDelegate {
    func loadThumbnailAd() {
        self.thumbnailAd = FreestarThumbnailAd(delegate: self)
        self.thumbnailAd?.selectPartners(self.chosenPartners)
        self.thumbnailAd?.loadPlacement(placementField.text)
    }

    func showThumbnailAd() {
        thumbnailAd?.show(from: self)
    }

    func freestarThumbnailLoaded(_ ad: FreestarThumbnailAd) {
        self.thumbnailAdReady = true
    }

    func freestarThumbnailFailed(_ ad: FreestarThumbnailAd, because reason: FreestarNoAdReason) {
        self.thumbnailAdReady = false
    }

    func freestarThumbnailShown(_ ad: FreestarThumbnailAd) {

    }

    func freestarThumbnailClicked(_ ad: FreestarThumbnailAd) {

    }

    func freestarThumbnailClosed(_ ad: FreestarThumbnailAd) {
        self.thumbnailAdReady = false
    }
}

