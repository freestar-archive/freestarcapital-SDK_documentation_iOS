//
//  PartnerSelectionTableViewController.swift
//  FreestarSwiftSample
//
//  Copyright © 2020 Freestar. All rights reserved.
//

import UIKit

struct PartnerChoice {
    var name: String
    var selected = false
}

protocol PartnerSelectionViewControllerDelegate: class {
    func partnersSelected(_ partners: [String])
}

class PartnerSelectionTableViewController: UITableViewController {
    
    var partnerList = [PartnerChoice]()
    weak var delegate: PartnerSelectionViewControllerDelegate?
    
    convenience init(adType: FreestarAdType, delegate: PartnerSelectionViewControllerDelegate? = nil) {
        self.init()
        self.partnerList = partnerListForAdType(adType)
        self.delegate = delegate
    }
    
    func partnerListForAdType(_ type: FreestarAdType) -> [PartnerChoice] {
        switch type {
        case .None: return []
        case .Interstitial: return [PartnerChoice(name: "All", selected: true)] + [
                "Chocolate",
                "AdColony",
                "GoogleAdmob",
                "Unity",
                "AppLovin",
                "Vungle",
                "Amazon",
                "Criteo",
                "Google" ].map { PartnerChoice(name: $0) }
        case .Rewarded: return [PartnerChoice(name: "All", selected: true)] + [
                "Chocolate",
                "AdColony",
                "GoogleAdmob",
                "Unity",
                "AppLovin",
                "Vungle",
                "Amazon",
                "Criteo",
                "Google",
                "Tapjoy" ].map { PartnerChoice(name: $0) }
        case .LargeBanner: return [PartnerChoice(name: "All", selected: true)] + [
                "Chocolate",
                "AppLovin",
                "GoogleAdmob",
                "Amazon",
                "Criteo",
                "Google" ].map { PartnerChoice(name: $0) }
        case .SmallBanner: return [PartnerChoice(name: "All", selected: true)] + [
                "GoogleAdmob",
                "Amazon",
                "Criteo",
                "AppLovin",
                "Unity" ].map { PartnerChoice(name: $0) }
        case .Preroll: return [PartnerChoice(name: "All", selected: true)] + [
                "Chocolate",
                "Google",
                "Amazon" ].map { PartnerChoice(name: $0) }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select Ad Partner";
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "partnerCell")
        
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .done,
                            target: self,
                            action: #selector(PartnerSelectionTableViewController.closeAndExit))
    }
    
    @objc func closeAndExit() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partnerList.count
    }

    //*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "partnerCell", for: indexPath)

        // Configure the cell...
        let pc = partnerList[indexPath.row]
        cell.textLabel?.text = pc.name
        cell.accessoryType = pc.selected ? .checkmark : .none

        return cell
    }
    //*/

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if partnerList[indexPath.row].name == "All"  {
            for i in 1..<partnerList.count {
                partnerList[i].selected = false
            }
            partnerList[indexPath.row].selected = true
        } else {
            partnerList[0].selected = false
            partnerList[indexPath.row].selected.toggle()
        }
        
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))
            cell?.accessoryType = partnerList[i].selected ? .checkmark : .none
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            self.delegate?.partnersSelected(self.extractChosenPartners())
        }
    }
    
    func extractChosenPartners() -> [String] {
        if partnerList[0].selected {
            return ["all"]
        }
        
        return partnerList.filter { $0.selected }.map { $0.name.lowercased() }
    }
}
