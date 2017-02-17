//
//  DetailViewController.swift
//  GeoSave
//
//  Created by valentinkajdan on 14/02/2017.
//  Copyright © 2017 valentinkajdan. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import MapKit

class DetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locValue = CLLocationCoordinate2D()
    

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameTextField: UITextField!

    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    
    func configureView() {
        
        // Update the user interface for the detail item.
        
                if let detail = self.detailItem {
                    if let label = self.nameTextField {
                        label.text = detail.title
                    }
                }

    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
//        self.determineCurrentLocation()
        
        // self.mapView.addAnnotation(detailItem)

    }
    
//    func determineCurrentLocation()
//    {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter = 100.0
//        
//        // Ask for Authorisation from the User.
//        locationManager.requestAlwaysAuthorization()
//        
//        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()
//        
//        if CLLocationManager.locationServicesEnabled() {
//            //locationManager.startUpdatingHeading()
//            locationManager.startUpdatingLocation()
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.locValue = location.coordinate
            
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
                    
                    let place = Geoplace(coordinate: self.locValue)
                    self.mapView.addAnnotation(place)
                }
            }
            
            //let center = AppDelegate.instance().center
            let camera = MKMapCamera(lookingAtCenter: self.locValue, fromEyeCoordinate:  self.locValue, eyeAltitude: 5000.0)
            self.mapView.setCamera(camera, animated: true)
        }
        
        // TODO : Enregistrer title après modification
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
       
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // update the map to set the user location
    var detailItem: Geoplace? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    
}


