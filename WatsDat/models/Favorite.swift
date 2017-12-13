//
//  Favorite.swift
//  WatsDat
//
//  Created by Swati Raghuwanshi on 12/9/17.
//  Copyright © 2017 Swati Raghuwanshi. All rights reserved.
//

import Foundation
import MapKit

class Favorite: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let favTitle: String
    let filename: URL?
    let latitude: Double?
    let longitude: Double?
    
    let favTitleKey = "favTitle"
    let favfilenameKey = "filename"
    let latitudeKey = "latitude"
    let longitudeKey = "longitude"
    
    init(favTitle: String, filename: URL, latitude: Double, longitude: Double) {
        
        self.favTitle = favTitle
        self.filename = filename
        self.latitude = latitude
        self.longitude = longitude
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        favTitle = aDecoder.decodeObject(forKey: favTitleKey) as! String
        filename = aDecoder.decodeObject(forKey: favfilenameKey) as? URL
        latitude = aDecoder.decodeObject(forKey: latitudeKey) as? Double
        longitude = aDecoder.decodeObject(forKey: longitudeKey) as? Double
        if let latitude = latitude, let longitude = longitude  {
            coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            coordinate = CLLocationCoordinate2D()
            
              }
    }
}

extension Favorite: NSCoding {
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(favTitle, forKey: favTitleKey)
        aCoder.encode(filename, forKey: favfilenameKey)
        aCoder.encode(latitude, forKey: latitudeKey)
        aCoder.encode(longitude, forKey: longitudeKey)
    
    }
}
extension Favorite {
    // to compare the wikipedia title while saving in favorites
    static func == (lhs: Favorite, rhs: Favorite) -> Bool{
        return (lhs.favTitle == rhs.favTitle)
    }
    
}

