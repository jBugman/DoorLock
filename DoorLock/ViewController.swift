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

    let beaconID = "61687109-905F-4436-91F8-E602F514C96D"
    let beaconMajor: CLBeaconMajorValue = 57005

    let nearBeaconMinor = 2284  // Тот, в который заходит питание.
    let farBeaconMinor = 2249

    var rssiThreshold = -50


    //    let nearBeaconID = "B959F4A6-64F3-DDD8-AA5B-B5F93711B3B2"
    //    let farBeaconID = "075F3C2D-270E-0037-7731-A8444A645908"

    @IBOutlet weak var beakonAvailableLabel: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var nearLabel: UILabel!
    @IBOutlet weak var farLabel: UILabel!

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
        println("Init regions")

        let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: beaconID), major: beaconMajor, identifier: "Near beacon")
        region.notifyEntryStateOnDisplay = true
        locationManager.startMonitoringForRegion(region)
        locationManager.startRangingBeaconsInRegion(region)
    }

    func isAuthorized(status: CLAuthorizationStatus) -> Bool {
        let result = status == CLAuthorizationStatus.Authorized
        label3?.text = "Access: " + (result ? "authorized" : "not authorized")
        return result
    }

    func notify(text: String) {
        let localNotification = UILocalNotification()
        localNotification.alertBody = text
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 0.1)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }


    // MARK: iOS API

    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if isAuthorized(status) {
            initRegions()
        }
    }

    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {

        var nearRssi = 0
        var farRssi = 0

        //        println("Range")
        for beacon in beacons {
            //            println(beacon)
            if beacon.minor == nearBeaconMinor {
                nearLabel?.text = String.localizedStringWithFormat("Near: %f.3 %d", beacon.accuracy.description, beacon.rssi)
                // beacon.proximity.rawValue
                nearRssi = beacon.rssi
            }
            if beacon.minor == farBeaconMinor {
                farLabel?.text = String.localizedStringWithFormat("Far: %f.3 %d", beacon.accuracy.description, beacon.rssi)
                farRssi = beacon.rssi
            }
        }
        if nearRssi > farRssi && nearRssi > rssiThreshold {
            println("Near beacon")
            notify("Near beacon")
        }
    }

    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("Entered", region)
        notify("Entered region")
    }

    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("Left", region)
        notify("Left region")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
