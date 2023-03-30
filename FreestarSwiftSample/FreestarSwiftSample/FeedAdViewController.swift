//
//  FeedAdViewController.swift
//  FreestarSwiftSample
//
//  Copyright © 2020 Freestar. All rights reserved.
//

import UIKit
import FreestarAds
import SnapKit
import SafariServices
import LoremIpsum

class FeedAdViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate, FreestarBannerAdDelegate {
    
    // MARK: TableView
    let tableView = UITableView()
    var safeArea: UILayoutGuide!

    // MARK: Properties
    let ArticleCellIdentifier = "ArticleCell"
    let ErrorMessageLabelTextColor = UIColor.gray
    let ErrorMessageFontSize: CGFloat = 16
    var partnerLabel: UILabel?
    var articles: [Article]? = []

    var banner1: FreestarBannerAd?
    var banner2: FreestarBannerAd?
    var banner3: FreestarBannerAd?
    var banners: [FreestarBannerAd?]?
    var isLoadedBanner1: Bool = false
    var isLoadedBanner2: Bool = false
    var isLoadedBanner3: Bool = false

    // MARK: Structs

    struct Article {
        let title: String?
        let url: URL?
        let by: String?
        let email: String?
        let score: Int?
    }

    // MARK: Initialization
    deinit {
    
    }
    
    // MARK: IBActions
    @IBAction func refresh(sender: UIBarButtonItem) {
        banner1?.loadPlacement(FeedConstants.bannerPlacement1)
        banner2?.loadPlacement(FeedConstants.bannerPlacement2)
        banner3?.loadPlacement(FeedConstants.bannerPlacement3)
        self.tableView.reloadData()
        retrieveArticles()
    }

    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
                      
        safeArea = view.layoutMarginsGuide
        loadTableVew()
        retrieveArticles()
        loadBanners()
    }
    
    func loadTableVew() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
        
    func anchorBanner(_ banner: UIView?, size: CGSize) {
        guard ((banner?.superview) != nil) else {
            return
        }

        if (banner == banner1) {
            if !isLoadedBanner1 {
                return
            }
        } else if(banner == banner2) {
            if !isLoadedBanner2 {
                return
            }
        } else if(banner == banner3) {
            if !isLoadedBanner3 {
                return
            }
        }
        
        banner!.clipsToBounds = true
        banner!.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(banner!.superview!)
            make.size.equalTo(size)
        }
    }
    
    // MARK: Navigation
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    // MARK: Freestar banner loading
    func loadBanners() {
        banner1 = FreestarBannerAd(delegate: self, andSize: .banner320x50)
        banner1?.delegate = self
        banner1?.backgroundColor = UIColor.cyan
        banner1?.layer.borderWidth = 1
        banner1?.loadPlacement(FeedConstants.bannerPlacement1)
        
        banner2 = FreestarBannerAd(delegate: self, andSize: .banner300x250)
        banner2?.delegate = self
        banner2?.backgroundColor = UIColor.cyan
        banner2?.layer.borderWidth = 1
        banner2?.loadPlacement(FeedConstants.bannerPlacement2)
        
        banner3 = FreestarBannerAd(delegate: self, andSize: .banner300x250)
        banner3?.delegate = self
        banner3?.backgroundColor = UIColor.cyan
        banner3?.layer.borderWidth = 1
        banner3?.loadPlacement(FeedConstants.bannerPlacement3)
        
        banners = [ banner1, banner2, banner3 ]
    }
    
    // MARK: Freestar banner tableview handling
    // determine if row index should be a banner row based on modulo
    func isBannerRow(_ row: Int) -> Bool {
          if (row % FeedConstants.listViewModulus) == 0 {
            return true
          }
          return false
    }

    func bannerForIndex(_ row: Int) -> FreestarBannerAd? {
        guard isBannerRow(row) else {
            return nil
        }
        let divisor = row / FeedConstants.listViewModulus
        let bannerIndex = divisor % FeedConstants.bannerCount
        guard let banners = banners else {
            return nil
        }
        
        return banners[bannerIndex]
    }
    
    func sizeForBannerIndex(_ row: Int) -> CGSize {
        guard isBannerRow(row) else {
            return CGSize.zero
        }
        let divisor = row / FeedConstants.listViewModulus
        let bannerIndex = divisor % FeedConstants.bannerCount
        switch bannerIndex {
            case 0:
                return CGSize(width: 320, height: 50)
            default:
                // default to medium rect
                return CGSize(width: 375, height: 250)
        }
    }
    
    // MARK: Activity indicator
    func add(spinner: SpinnerViewController) {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func remove(spinner: SpinnerViewController) {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }

    // MARK: Article retrieval
    func retrieveArticles() {
        let spinner = SpinnerViewController()
        add(spinner: spinner)
        
        let queue = DispatchQueue(label: "org.queue.serial")
        let group = DispatchGroup()
        group.enter()
        queue.async { [weak self] in
            guard let self = self else { return }
            self.loadArticles(completion: { group.leave() })
        }
        group.enter()
        queue.async {
            // delay to emulate refresh time
            sleep(1)
            group.leave()
        }
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.remove(spinner: spinner)
        }
    }
    
    func loadArticles(completion: (() -> Void)) {
        for _ in 0...FeedConstants.articleCount-1 {
            let name = LoremIpsum.firstName() + LoremIpsum.lastName()
            let email = LoremIpsum.email()
            let title = LoremIpsum.title()
            let url = FeedConstants.randomUrl!
            let score = Int.random(in: 1..<101)
            self.articles?.append(Article(title: title, url: url, by: name, email:  email, score: score))
        }
        completion()
    }

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeedConstants.articleCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: ArticleCellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: ArticleCellIdentifier)
        guard let articles = self.articles else {
            return cell!
        }                
        
        if articles.indices.contains(indexPath.row) {
            let article: Article? = articles[indexPath.row]
            if isBannerRow(indexPath.row) {
                let cell: UITableViewCell = UITableViewCell()
                cell.backgroundColor = UIColor.groupTableViewBackground
                guard let bannerView = bannerForIndex(indexPath.row) else {
                    return cell
                }
                cell.contentView.addSubview(bannerView)
                setupConstraints(bannerView)
                return cell
            } else {
                guard let article = article else { return cell! }
                cell?.textLabel?.text = article.title
                cell?.detailTextLabel?.text = "\(article.score!) points by \(article.by!) [\(article.email!)]"
                cell?.accessoryView?.isHidden = false
                return cell!
            }
        }
        return cell!
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard isBannerRow(indexPath.row) else {
            let article = articles?[indexPath.row]
            if let url = article?.url {
                guard #available(iOS 9, *) else { return }
                let webViewController = SFSafariViewController(url: url)
                webViewController.delegate = self
                present(webViewController, animated: true)
            }
            return
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isBannerRow(indexPath.row) {
          return sizeForBannerIndex(indexPath.row).height
        } else {
          // non-banner row
          return 50.0
        }
    }

    // MARK: SFSafariViewControllerDelegate
    @available(iOS 9, *)
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)

    }

    @available(iOS 9, *)
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    }
    
    func setupConstraints(_ banner: FreestarBannerAd) {
        guard banner.superview != nil else {
            return
        }
                
        banner.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(banner.frame.width)
            make.height.equalTo(banner.frame.height)
        }
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
    }
    
    func didUpdateBanner(_ ad: FreestarBannerAd, with size: CGSize) {
        setupConstraints(ad)
    }
    
    // MARK: Freestar banner delegate callbacks
    func freestarBannerLoaded(_ ad: FreestarBannerAd) {
        print("Function: \(#function)")
        
        ad.show()
        ad.layer.borderWidth = 1
        ad.layer.borderColor = UIColor.darkGray.cgColor
        setupConstraints(ad)
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
    }
       
    func freestarBannerFailed(_ ad: FreestarBannerAd, because reason: FreestarNoAdReason) {
        print("Function: \(#function)")
        
        print("freestarBannerFailed: \(reason.rawValue)")
        ad.layer.borderWidth = 3
        ad.layer.borderColor = UIColor.red.cgColor
    }

    func freestarBannerShown(_ ad: FreestarBannerAd) {
       print("Function: \(#function)")
    }

    func freestarBannerClicked(_ ad: FreestarBannerAd) {
       print("Function: \(#function)")
    }

    func freestarBannerClosed(_ ad: FreestarBannerAd) {
       print("Function: \(#function)")
    }
}
