//
//  LocationService.swift
//  Stormy
//
//  Created by Suthananth Arulanantham on 09.06.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate{
    let locationManager : CLLocationManager = CLLocationManager()
    var location : CLLocation? = nil
    dynamic var gotLocation : Bool = false
    var locationString:String = String()
    
    
    override init(){
        super.init()
        self.initLocationManager()
        self.updateLocation()
        
    }
    
    func initLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if gotLocation == false{
            let locationArray = locations as NSArray
            if let loc = locationArray.lastObject as? CLLocation{
                self.location = loc
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                    if error != nil{
                        println("Error: \(error.localizedDescription)")
                        return
                    }
                    if placemarks.count > 0{
                        if let pm = placemarks[0] as? CLPlacemark{
                            self.locationString = "\(pm.locality),\(pm.country)"
                            self.gotLocation = true
                        }
                    }
                })
            }
            locationManager.stopUpdatingLocation()
            
        }
        
        
    }
    
    func updateLocation(){
        
        self.locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("error: \(error.localizedDescription)")
    }
}
