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
    static let LANGUADE_CODE_QUERY = "&lang=\(Locale.preferredLanguages[0].split(separator: "-").first ?? "en")"
    static let WEATHER_ICON_URL = "https://openweathermap.org/img/wn/"
    static let CURRENT_DEVICE_LANGUAGE_ID = "\(Locale.preferredLanguages[0].split(separator: "-").first ?? "en")"
}
