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

    
    //@IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameTextField: UITextField!
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var userPosition = CLLocationCoordinate2D()
    
    
    @IBAction func enregistrer(_ sender: Any) {
        if let name = nameTextField.text {
            let place = Geoplace(coordinate: userPosition)
            place.saveMyLocation(title: name)
            self.master?.insertNewObject(geoplace: place)
        }
        
        print("yes")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidChange), name: NSNotification.Name.locationDidChange, object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        //self.configureView()
        
        
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
            }
            
            self.userPosition = userLocation.coordinate
        }
        
        let coordinate = userLocation.coordinate
      
        let camera = MKMapCamera(lookingAtCenter: coordinate, fromEyeCoordinate:  coordinate, eyeAltitude: 5000.0)
        self.mapView.setCamera(camera, animated: true)
        
//        if let geoplaces = AppDelegate.instance().geoplaces {
//            setAnnotations(with: geoplaces)
//        }
    }
    
    func configureView() {

        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

    }
    
    
}
