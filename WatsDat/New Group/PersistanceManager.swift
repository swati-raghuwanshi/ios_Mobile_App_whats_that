//
//  PersistanceManager.swift
//  WatsDat
//
//  Created by Swati Raghuwanshi on 12/9/17.
//  Copyright © 2017 Swati Raghuwanshi. All rights reserved.
//

import Foundation

class PersistanceManager {
    static let sharedInstance = PersistanceManager()
    
    let favoritesKey = "favorites"
    var localFavTitle = ""
    
    
    
    func fetchFavorites() -> [Favorite] {
        let userDefaults = UserDefaults.standard
        
        print("Fetching favorites")
        
        let data = userDefaults.object(forKey: favoritesKey) as? Data
        
        if let data = data {
            //data is not nil, so use it
            print("inside if let")
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [Favorite] ?? [Favorite]()
        }
        else {
            //data is nil
            print("data is nil")
            return [Favorite]()
        }
    }
    
    func checkIfFav(favTitle: String,filename: URL ) -> Bool  {
        // to do
        let favorites = fetchFavorites()
        let favorite = Favorite(favTitle: favTitle, filename: filename, latitude: 0.0, longitude: 0.0)
        
        for f in favorites {
            if favorite == f {
                return true
            }
        }
        return false
    }
    
    func saveFavorite(_ favorite: Favorite) {
        let userDefaults = UserDefaults.standard
        
        var favorites = fetchFavorites()
        //localFavTitle = favorite.favTitle
        favorites.append(favorite)
        print(favorites)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: favorites)
        
        userDefaults.set(data, forKey: favoritesKey)
    }
    
    func deleteFavorite(_ favorite: Favorite) {
        let userDefaults = UserDefaults.standard
        
        let favorites = fetchFavorites()
        
        let unfavTitle = favorites.filter {$0.favTitle != favorite.favTitle }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: unfavTitle)
        
        userDefaults.set(data, forKey: favoritesKey)
    }
}


