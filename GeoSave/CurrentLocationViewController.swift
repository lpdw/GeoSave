//
//  CurrentLocationViewController.swift
//  GeoSave
//
//  Created by mamihery on 16/02/2017.
//  Copyright © 2017 valentinkajdan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CurrentLocationViewController: UIViewController {
    
    var locValue = CLLocationCoordinate2D()
    
    //@IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameTextField: UITextField!
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    
    @IBAction func enregistrer(_ sender: Any) {
       // self.detailDescriptionLabel.text = "Enregistrer !"
        if let name = nameTextField.text {
            let place = Geoplace(coordinate: locValue, title: name)
            place.saveMyLocation(placename: name)
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        geoCoder.reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let placemark = placemarks?.last {
                print(placemark.debugDescription)
                let address = placemark.addressDictionary
                let title = address?["Street"] as? String
                _ = address?["City"] as? String
                
                self.nameTextField.text = title
                                    let place = Geoplace(coordinate: self.locValue, title : title!)
                                    self.mapView.addAnnotation(place)
            }
        }
        
        //let center = AppDelegate.instance().center
        let camera = MKMapCamera(lookingAtCenter: self.locValue, fromEyeCoordinate:  self.locValue, eyeAltitude: 5000.0)
        self.mapView.setCamera(camera, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        
        //        struct Location {
        //            let title: String
        //            let latitude: Double
        //            let longitude: Double
        //        }
        //
        //        let locations = [
        //            Location(title: "Campus ERDF GrDF",  latitude: 48.9283294, longitude: 2.30626715),
        //            Location(title: "Cinéma CGR Epinay",latitude: 48.9283294, longitude: 2.306267),
        //            Location(title: "Leroy Merlin Gennevilliers",latitude: 48.9283294, longitude: 2.306267),
        //        ]
        //
        //        for location in locations {
        //            let annotation = MKPointAnnotation()
        //            annotation.title = location.title
        //            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        //            mapView.addAnnotation(annotation)
        //        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.locValue = location.coordinate
            
        }
        
        
        // save my location
        //Geoplace(coordinate: locValue).saveMyLocation(placename: "test")
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
