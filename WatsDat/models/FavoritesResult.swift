//
//  FavoritesResult.swift
//  WatsDat
//
//  Created by Swati Raghuwanshi on 12/9/17.
//  Copyright © 2017 Swati Raghuwanshi. All rights reserved.
//

import Foundation


class Favorite: NSObject {
    
    let favTitle: String
    let filename: URL?
    
    
    
    let favTitleKey = "favTitle"
    let favfilenameKey = "filename"
    
    init(favTitle: String, filename: URL) {
        
        
        self.favTitle = favTitle
        self.filename = filename
    }
    
    required init?(coder aDecoder: NSCoder) {
        favTitle = aDecoder.decodeObject(forKey: favTitleKey) as! String
        filename = aDecoder.decodeObject(forKey: favfilenameKey) as? URL
        
    }
}

extension Favorite: NSCoding {
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(favTitle, forKey: favTitleKey)
        aCoder.encode(filename, forKey: favfilenameKey)
        
    }
}

