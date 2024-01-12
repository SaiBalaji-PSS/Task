//
//  Constants.swift
//  Task
//
//  Created by Sai Balaji on 11/01/24.
//

import Foundation

struct Constants{
    static let BASE_URL = "https://api.openweathermap.org/data/2.5/"
    static let API_KEY = "1ee3c0c87cdc9ece042bf32cab095d7b"
    static let API_KEY_QUERTY = "&appid=\(Constants.API_KEY)"
   
    
   //api.openweathermap.org/data/2.5/forecast?q={city name},{state code},{country code}&appid={API key}
    
    //api.openweathermap.org/data/2.5/forecast?lat=44.34&lon=10.99&appid={API key}
    
    
    //api.openweathermap.org/data/2.5/forecast/daily?q={city name},{country code}&cnt={cnt}&appid={API key}
    
    
    static let FORE_CAST_QUERY = "forecast?"

    
    
    
    
    
    //https://api.openweathermap.org/data/2.5/weather?q=London&appid={API key}
    static let WEATHER_ICON_URL = "https://openweathermap.org/img/wn/"
    static let LANGUADE_CODE_QUERY = "&lang=\(Locale.preferredLanguages[0].split(separator: "-").first ?? "en")"
    
    
    
    
    
    
    
    static let CURRENT_DEVICE_LANGUAGE_ID = "\(Locale.preferredLanguages[0].split(separator: "-").first ?? "en")"
}
