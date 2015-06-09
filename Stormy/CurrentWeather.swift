//
//  CurrentWeather.swift
//  Stormy
//
//  Created by Suthananth Arulanantham on 06.06.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import Foundation
import UIKit

enum Icon : String{
    case ClearDay = "clear-day"
    case ClearNight = "clear-night"
    case Rain = "rain"
    case Snow = "snow"
    case Sleet = "sleet"
    case Wind = "wind"
    case Fog = "fog"
    case Cloudy = "cloudy"
    case PartlyCloudyDay = "partly-cloudy-day"
    case PartlyCloudyNight = "partly-cloudy-night"
    
    
    func toImage()->UIImage?{
        var imageName:String
        switch self {
        case .ClearDay:
            imageName = "clear-day.png"
        case  .ClearNight:
            imageName = "clear-night.png"
        case .Cloudy:
            imageName = "cloudy.png"
        case .Fog:
            imageName = "fog.png"
        case .PartlyCloudyDay:
            imageName = "cloudy-day.png"
        case .PartlyCloudyNight:
            imageName = "cloudy-night.png"
        case .Rain:
            imageName = "rain.png"
        case .Sleet:
            imageName = "sleet.png"
        case .Snow:
            imageName = "snow.png"
        case .Wind:
            imageName = "wind.png"
        }
        return UIImage(named: imageName)
    }
    
}


struct CurrentWeather {
    let temperature : Int?
    let humidity : Int?
    let precipProbability : Int?
    let summary : String?
    var icon: UIImage? = UIImage(named: "default.png")
    
    init(weatherDictionary: [String:AnyObject]){
        if let temperatureF = weatherDictionary["temperature"] as? Int{
            self.temperature = (temperatureF - 30) / 2
        }
        else{
            self.temperature = nil
        }
        if let humidityFloat = weatherDictionary["humidity"] as? Float{
            self.humidity = Int(humidityFloat * 100)
        }else{
            humidity = nil
        }
        if let precipProbabilityFloat = weatherDictionary["precipProbability"] as? Float{
            self.precipProbability = Int(precipProbabilityFloat * 100)
        }else{
            self.precipProbability = nil
        }
        summary = weatherDictionary["summary"] as? String
        if let iconString = weatherDictionary["icon"] as? String,
            let weatherIcon :Icon = Icon(rawValue: iconString){
                println(iconString)
            self.icon = weatherIcon.toImage()
        }
    }
}