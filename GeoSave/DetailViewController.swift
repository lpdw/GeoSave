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
    
    var locationManager:CLLocationManager!
    var locValue=CLLocationCoordinate2D()
    
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!


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
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.locValue
        mapView.addAnnotation(annotation)
    }
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
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
        self.locValue = manager.location!.coordinate
        
        
        let place = Geoplace(coordinate: locValue);
        self.mapView.addAnnotation(place)
        
        
        
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


