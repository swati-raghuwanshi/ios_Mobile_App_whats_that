//
//  FavoritePhotosTableViewController.swift
//  WatsDat
//
//  Created by Swati Raghuwanshi on 12/9/17.
//  Copyright © 2017 Swati Raghuwanshi. All rights reserved.
//

import UIKit

class FavoritePhotosTableViewController: UITableViewController {
    
    var favorites = [Favorite]()
    var imageIcon = "map"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(named: imageIcon),style:.plain,target:self,action: #selector(mapTapped))
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favorites = PersistanceManager.sharedInstance.fetchFavorites()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath)
        
        // Configure the cell...
        let favorite = favorites[indexPath.row]
        cell.textLabel?.text = favorite.favTitle
        cell.imageView?.image = UIImage(contentsOfFile: (favorite.filename?.path)!)
        return cell
    }
    
    @objc func mapTapped()  {
        
        performSegue(withIdentifier: "mapViewSegue", sender: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favDetailSegue" {
            let myVC = segue.destination as! PhotoDetailsViewController
            let favorite = favorites[tableView.indexPathForSelectedRow!.row]
            
            myVC.titleHead = favorite.favTitle
            myVC.filename = favorite.filename
            myVC.latitude = favorite.latitude ?? 0.0
            myVC.longitude = favorite.longitude ?? 0.0
            
        }
    }
}

