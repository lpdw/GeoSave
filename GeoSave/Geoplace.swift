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
    let defaults = UserDefaults.standard
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
    
    
    func saveMyLocation(placename: String) {
        //let newCoordinate = self.defaults.array(forKey: "a")
        self.defaults.set(self.coordinate, forKey: placename)
        self.defaults.synchronize()
    }
}
