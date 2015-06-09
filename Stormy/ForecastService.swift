//
//  ForecastService.swift
//  Stormy
//
//  Created by Suthananth Arulanantham on 07.06.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import Foundation
struct ForecastService {
    let forecastAPIKey: String
    let forecastBaseURL: NSURL?
    
    init(APIKey:String){
        self.forecastAPIKey = APIKey
        forecastBaseURL = NSURL(string: "https://api.forecast.io/forecast/\(self.forecastAPIKey)/")
    }
    
    func getForecast(lat:Double, long: Double, completion:(CurrentWeather?)->Void){
        if let forecastURL = NSURL(string: "\(lat),\(long)", relativeToURL: self.forecastBaseURL){
            let networkOperation = NetworkOperation(url: forecastURL)
            networkOperation.downloadJSONFromURL({ (JSONDictionary) -> Void in
                let currentWeather = self.currentWeatherFromJSON(JSONDictionary)
                completion(currentWeather)
            })
            
        }else{
            println("Could not construct a valid URL")
        }
    }
    
    func currentWeatherFromJSON(jsonDictionary: [String:AnyObject]?)->CurrentWeather?{
        if let currentWeatherDictionary = jsonDictionary?   ["currently"] as? [String:AnyObject]{
            return CurrentWeather(weatherDictionary: currentWeatherDictionary)
        }else{
            println("JSON dictinary returned 'nil' for currently key")
            return nil
        }
    }
}