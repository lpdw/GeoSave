//
//  Geoplace.swift
//  GeoSave
//
//  Created by mamihery on 15/02/2017.
//  Copyright © 2017 valentinkajdan. All rights reserved.
//

import UIKit
import MapKit

class Geoplace: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
//        self.title = title
        super.init()
    }
    
    
    func saveMyLocation(title: String) {
        let defaults = UserDefaults.standard
        self.title = title
        let newCoordinate = defaults.array(forKey: title)
        defaults.set(newCoordinate, forKey: title)
        defaults.synchronize()
    }
}
