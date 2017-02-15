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
    
    var locValue=CLLocationCoordinate2D()
    
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()

    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        self.determineCurrentLocation()
        struct Location {
            let title: String
            let latitude: Double
            let longitude: Double
        }
        
       /* let locations = [
            Location(title: "New York, NY",    latitude: 40.713054, longitude: -74.007228),
            Location(title: "Los Angeles, CA", latitude: 34.052238, longitude: -118.243344),
            Location(title: "Chicago, IL",     latitude: 41.883229, longitude: -87.632398)
        ]
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location.title
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            mapView.addAnnotation(annotation)
        }*/
    }
    
    func determineCurrentLocation()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0
        
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
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
                    let place = Geoplace(coordinate: self.locValue)
                    place.title = address?["Street"] as? String
                    place.subtitle = address?["City"] as? String
                    self.mapView.addAnnotation(place)
                }
            }
            
            
            let camera = MKMapCamera(lookingAtCenter: self.locValue, fromEyeCoordinate:  self.locValue, eyeAltitude: 5000.0)
            self.mapView.setCamera(camera, animated: true)
        }
        
        
        
        
        
        
        // save my location
        //Geoplace(coordinate: locValue).saveMyLocation(placename: "test")
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
       
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // update the map to set the user location
    var detailItem: NSDate? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    
}


