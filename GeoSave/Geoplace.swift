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
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
        super.init()
    }
    
    
    func saveMyLocation(placename: String) {
        let defaults = UserDefaults.standard
        //let newCoordinate = self.defaults.array(forKey: "a")
        defaults.set(self.coordinate, forKey: placename)
        defaults.synchronize()
    }
}
