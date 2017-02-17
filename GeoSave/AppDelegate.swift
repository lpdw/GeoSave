//
//  AppDelegate.swift
//  GeoSave
//
//  Created by valentinkajdan on 14/02/2017.
//  Copyright © 2017 valentinkajdan. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import Alamofire

let centerLat = 48.831034
let centerLon = 2.355265

extension Notification.Name {
    static let locationDidChange = Notification.Name("locationDidChange")
    static let geoplacesDidChange = Notification.Name("geoplacesDidChange")
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    
    let locationManager = CLLocationManager()
    let center = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
    
    var geoplaces: [[String: Any]]? {
        didSet {
            let notification = Notification(name: Notification.Name.geoplacesDidChange)
            NotificationCenter.default.post(notification)
        }
    }
    
    var userLocation: CLLocation? {
        didSet {
            let notification = Notification(name: Notification.Name.locationDidChange, object: userLocation, userInfo: nil)
            NotificationCenter.default.post(notification)
        }
    }
    
    class func instance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // UserDefaults sample code
        let defaults = UserDefaults.standard
        
        defaults.set([1, 2], forKey: "a")
        defaults.synchronize()
        
        let _ = defaults.array(forKey: "a")
        
        
        // Notification sample code
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidChange), name: NSNotification.Name.locationDidChange, object: nil)
        
        
        // !!! Don't do that this way !!!
        self.startLocate()

        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

}

// MARK: - Fountains methods
extension AppDelegate {
    
    func locationDidChange(notification: Notification) {
        guard let userLocation = notification.object as? CLLocation else { return }
        
        fetchGeoplaces(around: userLocation)
    }
    
    func fetchGeoplaces(around location: CLLocation) {
        
        let urlString = "http://api.eaupen.net/closest"
        let parameters: [String: Any] = [
            "accept": "application/json",
            "lat": location.coordinate.latitude,
            "lon": location.coordinate.longitude,
            "limit": 50,
            "range": 1500
        ]
        
        Alamofire
            .request(urlString, parameters: parameters)
            .validate()
            .responseJSON { (response: DataResponse<Any>) in
                
                switch response.result {
                    
                case .success(let json):
                    self.geoplaces = json as? [[String: Any]]
                    
                case .failure(let error):
                    print(error)
                }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension AppDelegate: CLLocationManagerDelegate {
    
    func startLocate() {
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 100.0
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations: \(locations)")
        
        self.userLocation = locations.last
    }
    
}


