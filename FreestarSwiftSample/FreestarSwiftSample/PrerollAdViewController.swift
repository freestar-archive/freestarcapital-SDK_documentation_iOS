//
//  PrerollAdViewController.swift
//  FreestarSwiftSample
//
//  Created by Vdopia Developer on 3/31/20.
//  Copyright © 2020 Freestar. All rights reserved.
//

import UIKit
import FreestarAds

class PrerollAdViewController: AdViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func loadChosenAd() {
        
    }
    
    override func showChosenAd() {
        
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
        
    }
    
    func showPrerollAd() {
        
    }
    
    func freestarPrerollLoaded(_ ad: FreestarPrerollAd) {
        
    }
    
    func freestarPrerollFailed(_ ad: FreestarPrerollAd, because reason: FreestarNoAdReason) {
        
    }
    
    func freestarPrerollShown(_ ad: FreestarPrerollAd) {
        
    }
    
    func freestarPrerollClicked(_ ad: FreestarPrerollAd) {
        
    }
    
    func freestarPrerollClosed(_ ad: FreestarPrerollAd) {
        
    }
    
    func freestarPrerollFailed(toStart ad: FreestarPrerollAd, because reason: FreestarNoAdReason) {
        
    }
    
    
}
