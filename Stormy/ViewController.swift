//
//  ViewController.swift
//  Stormy
//
//  Created by Suthananth Arulanantham on 06.06.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var refreshButton: UIButton?
    @IBOutlet weak var currentWeatherLocation: UILabel!
    @IBOutlet weak var currentWeatherSummary: UILabel?
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var currentHumidityLabel: UILabel?
    @IBOutlet weak var currentPercipitationLabel: UILabel?
    
    private let forecastAPIkey = "361605406536cd53ca3421678062daf8"
    var coordinate : (lat:Double,lon:Double) = (lat:0,lon:0)
    let locationService = LocationService()
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // self.retrieveForecast()
        self.refreshWeather()
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        self.coordinate.lat = Double(self.locationService.location!.coordinate.latitude)
        self.coordinate.lon = Double(self.locationService.location!.coordinate.longitude)
        self.locationService.removeObserver(self, forKeyPath: "gotLocation")
        self.locationService.gotLocation = false
        self.retrieveForecast()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveForecast(){
        let foreCastService = ForecastService(APIKey: self.forecastAPIkey)
        
        foreCastService.getForecast(coordinate.lat, long: coordinate.lon){
            (let currently) in
            if let currentWeather = currently{
                println(currentWeather.icon?.description)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let temperature = currentWeather.temperature{
                        self.currentTemperatureLabel?.text = "\(temperature)°"
                    }
                    if let humidity = currentWeather.humidity{
                        self.currentHumidityLabel?.text = "\(humidity)%"
                    }
                    if let percp = currentWeather.precipProbability{
                        self.currentPercipitationLabel?.text = "\(percp)%"
                    }
                    if let icon = currentWeather.icon {
                        self.currentWeatherIcon?.image = icon
                    }
                    if let summary = currentWeather.summary{
                        self.currentWeatherSummary?.text = summary
                    }
                    self.currentWeatherLocation.text = self.locationService.locationString
                    self.toggeRefreshAnimation(false)
                })
            }
        }
    }
    @IBAction func refreshWeather() {
        self.toggeRefreshAnimation(true)
        //self.retrieveForecast()
        
    }
    
    func toggeRefreshAnimation(on:Bool){
        self.refreshButton?.hidden = on
        if on {
            self.implementObserver()
            self.locationService.updateLocation()
            activityIndicator?.startAnimating()
        }else{
            activityIndicator?.stopAnimating()
        }
    }
    
    func implementObserver(){
        self.locationService.addObserver(self, forKeyPath: "gotLocation", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
}

