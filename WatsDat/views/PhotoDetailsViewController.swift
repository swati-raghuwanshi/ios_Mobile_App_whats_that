//
//  PhotoDetailsViewController.swift
//  WatsDat
//
//  Created by Swati Raghuwanshi on 12/9/17.
//  Copyright © 2017 Swati Raghuwanshi. All rights reserved.
//

import UIKit
import SafariServices
import MBProgressHUD

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet weak var Header: UILabel!
    
    
    @IBOutlet weak var Extract: UITextView!
    
    var titleHead = ""
    var wikiExtract = ""
    var wikiPageid: Int = 0
    var filename: URL?
    var isFavorite = false
    var imageIcon = ""
    var latitude = 0.0
    var longitude = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Header.text = titleHead
        
        let wikiAPI = WikipediaAPIManager()
        
        //designate self as the receiver of the fetchWikiData callbacks
        wikiAPI.delegate = self
        wikiAPI.fetchWikiData(searchString: titleHead)
        if PersistanceManager.sharedInstance.checkIfFav(favTitle: titleHead, filename: filename!){
            //true
            imageIcon = "heart"
            isFavorite = true
            
        }else{//false
            imageIcon = "heartLess"
            isFavorite = false
        }
        
        
        
        //create a button
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(named: imageIcon),style:.plain,target:self,action: #selector(favIconTapped))
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func favIconTapped() {
        if isFavorite {
            isFavorite = false
            imageIcon = "heartLess"
            
            deleteFavorite()
            
        } else {
            isFavorite = true
            imageIcon = "heart"
            saveFavorite()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(named:imageIcon),style:.plain,target:self,action: #selector(favIconTapped))
    }
    
    func saveFavorite()  {
        let favorite = Favorite(favTitle: titleHead, filename: filename!, latitude: latitude, longitude: longitude)
        
        PersistanceManager.sharedInstance.saveFavorite(favorite)
        
        
        
    }
    
    func deleteFavorite()  {
        
        
        let favorite = Favorite(favTitle: titleHead, filename: filename!,latitude: latitude, longitude: longitude)
        
        
        PersistanceManager.sharedInstance.deleteFavorite(favorite)
        
    }
    
    
    
    
    @IBAction func visitWikiPage(_ sender: UIButton) {
        
        
        if let url = URL(string: "https://en.wikipedia.org/?curid=\(wikiPageid)") {
            print(url.absoluteString)
            
            let vc = SFSafariViewController(url: url)
            
            present(vc, animated: true)
        }
    }
    
    
    @IBAction func shareData(_ sender: UIButton) {
        
        let activityVC = UIActivityViewController(activityItems: ["https://en.wikipedia.org/?curid=\(wikiPageid)"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    @IBAction func twitterData(_ sender: UIButton) {
        
        let vc = SearchTimelineViewController()
        vc.query = titleHead
        //present(vc, animated: true)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}

extension PhotoDetailsViewController: ApproximateDataDelegate {
    func dataFound(wiki: Wiki) {
        self.wikiExtract = wiki.extract
        self.wikiPageid = wiki.pageid
        print(wiki.pageid)
        DispatchQueue.main.async {
            self.Extract.text = self.wikiExtract
            
        }
    }
    
    
    func dataNotFound(reason: WikipediaAPIManager.FailureReason) {
        DispatchQueue.main.async {
            
            let ac = UIAlertController(title:"Error Message", message: reason.rawValue, preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: .default)
            
            ac.addAction(cancelButton)
            
            self.present(ac, animated: true, completion: nil)
            
        }
    }
}



