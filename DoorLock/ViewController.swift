//
//  ViewController.swift
//  DoorLock
//
//  Created by Sergey Parshukov on 31.10.14.
//  Copyright (c) 2014 Interactive Lab. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var beakonAvailableLabel: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    let locationManager = CLLocationManager()
    
    func initialize() {
        locationManager.delegate = self
        
        let beaconsAvailable = CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion)
        beakonAvailableLabel?.text = "Beacons: " + (beaconsAvailable ? "available" : "not available")
 
        if(beaconsAvailable) {
            if(isAuthorized(CLLocationManager.authorizationStatus())) {
                initRegions()
            } else {
                locationManager.requestAlwaysAuthorization()
            }
        }
        
        let backgroundAvailable = UIApplication.sharedApplication().backgroundRefreshStatus == UIBackgroundRefreshStatus.Available
        label2?.text = "Background refresh: " + (backgroundAvailable ? "OK" : "Disabled")
    }
    
    func initRegions() {
    }
    
    func isAuthorized(status: CLAuthorizationStatus) -> Bool {
        let result = status == CLAuthorizationStatus.Authorized
        label3?.text = "Access: " + (result ? "authorized" : "not authorized")
        return result
    }


    
    // MARK: iOS API
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if isAuthorized(status) {
            initRegions()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
