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
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
