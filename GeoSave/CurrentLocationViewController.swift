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
    
    var master: MasterViewController?
    var locValue = CLLocationCoordinate2D()
    
    //@IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameTextField: UITextField!
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    
    @IBAction func enregistrer(_ sender: Any) {
       // self.detailDescriptionLabel.text = "Enregistrer !"
//        if let name = nameTextField.text {
//            let place = Geoplace(coordinate: locValue, title: name)
//            place.saveMyLocation(placename: name)
//        }
        
        print("yes")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidChange), name: NSNotification.Name.locationDidChange, object: nil)
        
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
    
    
    func locationDidChange(notification: Notification) {
        guard let userLocation = notification.object as? CLLocation else { return }
        
        geoCoder.reverseGeocodeLocation(userLocation) { (placemarks: [CLPlacemark]?, error: Error?) in
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
                let place = Geoplace(coordinate: self.locValue)
                self.mapView.addAnnotation(place)
            }
        }
        
        let coordinate = userLocation.coordinate
        let camera = MKMapCamera(lookingAtCenter: coordinate, fromEyeCoordinate:  coordinate, eyeAltitude: 5000.0)
        self.mapView.setCamera(camera, animated: true)
        
//        if let geoplaces = AppDelegate.instance().geoplaces {
//            setAnnotations(with: geoplaces)
//        }
    }
    
    
    func setAnnotations(with fountains: [[String: Any]]) {
        
        let centerLocation = CLLocation(latitude: centerLat, longitude: centerLon)
       
        
        let annotations = fountains
            .flatMap { (content: [String : Any]) -> MKAnnotation? in
                if  let loc = content["loc"] as? [String: Any],
                    let lat = loc["lat"] as? CLLocationDegrees,
                    let lon = loc["lon"] as? CLLocationDegrees
                {
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    let geoplaces = Geoplace(coordinate: coordinate)
                    return geoplaces
                }
                return nil
            }
            .sorted { /* (f0: MKAnnotation, f1: MKAnnotation) -> Bool in */
                let location0 = CLLocation(latitude: $0.coordinate.latitude,
                                           longitude: $0.coordinate.longitude)
                let location1 = CLLocation(latitude: $1.coordinate.latitude,
                                           longitude: $1.coordinate.longitude)
                let distance0 = centerLocation.distance(from: location0)
                let distance1 = centerLocation.distance(from: location1)
                
                return distance0 < distance1
        }
        
        self.mapView.addAnnotations(annotations)
    }
    

    
    
    func configureView() {
//                let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
//                geoCoder.reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: Error?) in
//                    if let error = error {
//                        print(error.localizedDescription)
//                        return
//                    }
//        
//                    if let placemark = placemarks?.last {
//                        print(placemark.debugDescription)
//                        let address = placemark.addressDictionary
//                        let title = address?["Street"] as? String
//                        _ = address?["City"] as? String
//        
//                        self.nameTextField.text = title
//                        let place = Geoplace(coordinate: self.locValue)
//                        self.mapView.addAnnotation(place)
//                    }
//                }
//        
//                //let center = AppDelegate.instance().center
//                let camera = MKMapCamera(lookingAtCenter: self.locValue, fromEyeCoordinate:  self.locValue, eyeAltitude: 5000.0)
//                self.mapView.setCamera(camera, animated: true)
    }
    
    
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.locValue = location.coordinate
            
        }
        
         // TODO : Enregistrer la position actuelle
        // save my location
//        Geoplace(coordinate: locValue).saveMyLocation(placename: "test")
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

    }
    
    
}
