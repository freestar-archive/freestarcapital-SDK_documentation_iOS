//
//  UIViewController+FreestarUISetup.swift
//  FreestarSwiftSample
//
//  Created by Vdopia Developer on 3/30/20.
//  Copyright © 2020 Freestar. All rights reserved.
//

import Foundation
import UIKit

enum FreestarAdType {
    case None
    case Interstitial
    case Rewarded
    case SmallBanner
    case LargeBanner
    case Preroll
}

class AdViewController : UIViewController, UITextFieldDelegate, PartnerSelectionViewControllerDelegate {
    
    let placementField = UITextField()
    
    let concreteAdTypeSelector = UISegmentedControl(items: ["", ""])
    let partnerSelectionPrompt = UILabel()
    let partnerSelectionToggle = UISwitch()
    
    let loadButton = UIButton(type: .system)
    let showButton = UIButton(type: .system)
    
    var chosenPartners = [String]()
    
    var enablePartnerSelection = false {
        didSet {
            partnerSelectionToggle.isHidden = !enablePartnerSelection
            partnerSelectionPrompt.isHidden = !enablePartnerSelection
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            self.view.backgroundColor = .white
        }
        
        setupPlacementField()
        setupLoadSelectionUI()
        setupLoadAndShowButtons()
    }
    
    // MARK: - UI Setup
    
    func setupPlacementField() {
        placementField.autocapitalizationType = .none
        placementField.placeholder = "Ad Placement"
        placementField.delegate = self
        placementField.returnKeyType = .done
        placementField.textAlignment = .center
        placementField.borderStyle = .roundedRect
        
        guard let nbSize = self.navigationController?.navigationBar.bounds.size else { return }
        placementField.frame = CGRect(x: 0, y: 0, width: nbSize.width - 100, height: nbSize.height - 10)
        self.navigationItem.titleView = placementField
    }
    
    func setupLoadSelectionUI() {
        for(index, element) in self.concreteAdTypes().enumerated() {
            concreteAdTypeSelector.setTitle(element, forSegmentAt: index)
        }
        
        concreteAdTypeSelector.addTarget(self,
            action: #selector(AdViewController.updateShowButton),
            for: .valueChanged)
        
        self.view.addSubview(concreteAdTypeSelector)
        concreteAdTypeSelector.translatesAutoresizingMaskIntoConstraints = false
        concreteAdTypeSelector.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        concreteAdTypeSelector.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        concreteAdTypeSelector.selectedSegmentIndex = 0
        
        self.view.addSubview(partnerSelectionToggle)
        partnerSelectionToggle.translatesAutoresizingMaskIntoConstraints = false
        partnerSelectionToggle.centerYAnchor.constraint(equalTo: concreteAdTypeSelector.centerYAnchor).isActive = true
        partnerSelectionToggle.leadingAnchor.constraint(equalTo: concreteAdTypeSelector.trailingAnchor, constant: 10).isActive = true
        
        partnerSelectionPrompt.font = UIFont.preferredFont(forTextStyle: .body)
        partnerSelectionPrompt.text = "Choose Partner"
        partnerSelectionPrompt.sizeToFit()
        self.view.addSubview(partnerSelectionPrompt)
        partnerSelectionPrompt.translatesAutoresizingMaskIntoConstraints = false
        partnerSelectionPrompt.centerYAnchor.constraint(equalTo: concreteAdTypeSelector.centerYAnchor).isActive = true
        partnerSelectionPrompt.leadingAnchor.constraint(equalTo: partnerSelectionToggle.trailingAnchor, constant: 10).isActive = true
    }
    
    func setupLoadAndShowButtons() {
        loadButton.setTitle("Load", for: .normal)
        loadButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        loadButton.addTarget(self,
                             action:#selector(AdViewController.loadAd),
                             for: .touchUpInside)
        self.view.addSubview(loadButton)
        loadButton.translatesAutoresizingMaskIntoConstraints = false
        loadButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        loadButton.topAnchor.constraint(equalTo: concreteAdTypeSelector.bottomAnchor, constant: 10).isActive = true
        
        showButton.setTitle("Show", for: .normal)
        showButton.isEnabled = false
        showButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        showButton.addTarget(self,
                             action:#selector(AdViewController.showAd),
                             for: .touchUpInside)
        self.view.addSubview(showButton)
        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.leftAnchor.constraint(equalTo: loadButton.rightAnchor, constant: 20).isActive = true
        showButton.topAnchor.constraint(equalTo: loadButton.topAnchor).isActive = true
    }
    
    
    @objc func loadAd() {
        if partnerSelectionToggle.isOn {
            self.navigationController?.pushViewController(PartnerSelectionTableViewController(adType: self.selectedAdType(), delegate: self), animated: true)
        } else {
            chosenPartners = []
            loadChosenAd()
        }
    }
    
    @objc func showAd() {
        showChosenAd()
    }
    
    // MARK: - methods to override in subclasses
    func loadChosenAd() {}
    func showChosenAd() {}
    
    func selectedAdType() -> FreestarAdType {
        return .None
    }
    
    @objc func updateShowButton() {}
    
    func concreteAdTypes() -> [String] { return [] }
    
    // MARK: - UITextFieldDelegate
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - PartnerSelectionViewControllerDelegate
    
    func partnersSelected(_ partners: [String]) {
        self.chosenPartners = partners
        loadChosenAd()
    }
}
