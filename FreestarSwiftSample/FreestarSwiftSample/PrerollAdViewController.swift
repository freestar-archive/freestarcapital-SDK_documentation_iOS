//
//  PrerollAdViewController.swift
//  FreestarSwiftSample
//
//  Created by Vdopia Developer on 3/31/20.
//  Copyright © 2020 Freestar. All rights reserved.
//

import UIKit
import FreestarAds
import AVKit


class PrerollAdViewController: AdViewController {
    
    static let CONTENT = "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_30mb.mp4"
    
    let publisherVideo = AVPlayerViewController()
    
    var prerollAdReady = false {
        didSet {
            showButton.isEnabled = self.prerollAdReady
        }
    }
    
    var prerollAd: FreestarPrerollAd?
    var fullscreenAdContainer : UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupPublisherVideo()
        
        self.enablePartnerSelection = false
    }
    
    func setupPublisherVideo() {
        publisherVideo.player = AVPlayer(url: sampleContentVideo())
        self.view.addSubview(publisherVideo.view)
        publisherVideo.view.translatesAutoresizingMaskIntoConstraints = false
        publisherVideo.view.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true
        publisherVideo.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        let nativePortraitWidth = UIScreen.main.nativeBounds.size.width/UIScreen.main.scale
        publisherVideo.view.widthAnchor.constraint(equalToConstant: nativePortraitWidth).isActive = true
        publisherVideo.view.heightAnchor.constraint(equalTo: publisherVideo.view.widthAnchor,
            multiplier: 0.5625).isActive = true
        
        publisherVideo.player?.actionAtItemEnd = .none
        publisherVideo.showsPlaybackControls = false
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(PrerollAdViewController.mainContentDone),
            name: Notification.Name.AVPlayerItemDidPlayToEndTime,
            object: publisherVideo.player?.currentItem)
    }
    
    //MARK: - Video Playback
    
    func sampleContentVideo() -> URL {
        guard let local = Bundle.main.url(forResource: "bunny", withExtension: "mp4") else {
            return URL(string: PrerollAdViewController.CONTENT)!
        }
        return local
    }
    
    @objc func mainContentDone(_ not: Notification) {
        if let p = not.object as? AVPlayerItem {
            p.seek(to: .zero)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        publisherVideo.player?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        publisherVideo.player?.pause()
    }
    
    
    //MARK: - Ad Management

    override func loadChosenAd() {
        loadPrerollAd()
    }
    
    override func showChosenAd() {
        showPrerollAd()
    }

    
    override func selectedAdType() -> FreestarAdType {
        return .Preroll
    }
    
    override func concreteAdTypes() -> [String] {
        return ["In Video", "Fullscreen"]
    }

}

extension PrerollAdViewController : FreestarPrerollAdDelegate {
    func loadPrerollAd() {
        self.prerollAd = FreestarPrerollAd(placement: placementField.text)
        prerollAd?.delegate = self
    }
    
    func showPrerollAd() {
        self.prerollAdReady = false
        publisherVideo.player?.pause()
        
        if concreteAdTypeSelector.selectedSegmentIndex == 0 {
            self.prerollAd?.playOver(publisherVideo)
        } else {
            fullscreenAdContainer = UIViewController()
            fullscreenAdContainer?.modalPresentationStyle = .fullScreen
            self.present(fullscreenAdContainer!, animated: true) {
                self.prerollAd?.play(in: self.fullscreenAdContainer!.view,
                                     at: self.fullscreenAdContainer!.view.center)
            }
        }
    }
    
    func freestarPrerollLoaded(_ ad: FreestarPrerollAd) {
        self.prerollAdReady = true
    }
    
    func freestarPrerollFailed(_ ad: FreestarPrerollAd, because reason: FreestarNoAdReason) {
        self.prerollAdReady = false
    }
    
    func freestarPrerollShown(_ ad: FreestarPrerollAd) {
        
    }
    
    func freestarPrerollClicked(_ ad: FreestarPrerollAd) {
        
    }
    
    func freestarPrerollClosed(_ ad: FreestarPrerollAd) {
        self.prerollAdReady = false
        guard let fsac = self.fullscreenAdContainer else { return }
        fsac.dismiss(animated: true) {
            self.fullscreenAdContainer = nil
            self.publisherVideo.player?.play()
        }
    }
    
    func freestarPrerollFailed(toStart ad: FreestarPrerollAd, because reason: FreestarNoAdReason) {
        publisherVideo.player?.play()
    }
    
    
}
