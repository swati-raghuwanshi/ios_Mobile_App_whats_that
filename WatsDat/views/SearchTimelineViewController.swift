//
//  SearchTimelineTableViewController.swift
//  WatsDat
//
//  Created by Swati Raghuwanshi on 12/9/17.
//  Copyright © 2017 Swati Raghuwanshi. All rights reserved.
//

import UIKit
import TwitterKit


class SearchTimelineViewController: TWTRTimelineViewController {

    var query = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dataSource = TWTRSearchTimelineDataSource(searchQuery: query, apiClient: TWTRAPIClient())
        
        dataSource.resultType = "popular"
        self.dataSource = dataSource
    }
}
