//
//  WeatherModel.swift
//  Click2Weather
//
//  Created by Alexander Kovzhut on 04.01.2022.
//

import Foundation

struct WeatherModel {
    let dayTime: Int //Dt
    let timezone: Int //Timezone
    let cityName: String //Name
    let countryName: String //Sys.country
    let conditionId: Int //Weather.id
    let temperature: Double //Main.temp
    let mainDescription: String //Weather.main
    //let secondarydDescription: String //Weather.description
    let tempMax: Double //Main.temp_max
    let tempMin: Double //Main.temp_min
    let tempFeelsLike: Double //Main.feels_like
    let windSpeed: Double //Wind.speed
    let windDegrees: Int //Wind.deg
    let pressure: Int //Main.pressure
    let humidity: Double //Main.humidity
    let visibility: Int //Visibility
    //Bring weather features to string
    var tempString: String {
        return String(format: "%.0f", temperature)
    }
    
    var tempMaxString: String {
        return String(format: "%.0f", tempMax)
    }
    
    var tempMinString: String {
        return String(format: "%.0f", tempMin)
    }
    
    var tempFeelsLikeString: String {
        return String(format: "%.0f", tempFeelsLike)
    }
    
    var windSpeedString: String {
        return String(windSpeed)
    }
    
    var windDegreesString: String {
        return String(windDegrees)
    }
    
    var humidityString: String {
        return String(format: "%.0f", humidity)
    }
    
    var visibilityString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: visibility))
        return formattedNumber!
    }
    
    var pressureString: String {
        return String(pressure)
    }
    
    //Date formatter
    //var date =
    //Switch to system icon variants
    var conditionName: String {
        switch conditionId {
        case 200...232: return "cloud.bolt"
        case 300...321: return "cloud.drizzle"
        case 500...531: return "cloud.rain"
        case 600...622: return "cloud.snow"
        case 701...781: return "cloud.fog"
        case 800: return "sun.max"
        case 801...804: return "cloud.bolt"
        default: return "cloud"
        }
    }
    
    //var date = NSDate
}
