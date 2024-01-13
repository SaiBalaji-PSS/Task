//
//  ForecastModel.swift
//  Task
//
//  Created by Sai Balaji on 11/01/24.
//

import Foundation

enum ForecastModel{
    struct ForecastModelResponse: Codable {
        let cod: String?
        var message: RelaxedString?
        let cnt: Int?
        let list: [List]?
        let city: City?
        var messageString: String? {
                get { message?.value }
                set { message = newValue.map(RelaxedString.init) }
            }
    }

    // MARK: - City
    struct City: Codable {
        let id: Int?
        let name: String?
        let coord: Coord?
        let country: String?
        let population, timezone, sunrise, sunset: Int?
    }

    // MARK: - Coord
    struct Coord: Codable {
        let lat, lon: Double?
    }

    // MARK: - List
    struct List: Codable {
        let dt: Int?
        let main: Main?
        let weather: [Weather]?
        let clouds: Clouds?
        let wind: Wind?
        let visibility: Int?
        let pop: Double?
        let rain: Rain?
        let sys: Sys?
        let dtTxt: String?

        enum CodingKeys: String, CodingKey {
            case dt, main, weather, clouds, wind, visibility, pop, rain, sys
            case dtTxt = "dt_txt"
        }
    }

    // MARK: - Clouds
    struct Clouds: Codable {
        let all: Int?
    }

    // MARK: - Main
    struct Main: Codable {
        let temp, feelsLike, tempMin, tempMax: Double?
        let pressure, seaLevel, grndLevel, humidity: Int?
        let tempKf: Double?

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
            case humidity
            case tempKf = "temp_kf"
        }
    }

    // MARK: - Rain
    struct Rain: Codable {
        let the3H: Double?

        enum CodingKeys: String, CodingKey {
            case the3H = "3h"
        }
    }

    // MARK: - Sys
    struct Sys: Codable {
        let pod: String?
    }

    // MARK: - Weather
    struct Weather: Codable {
        let id: Int?
        let main, description, icon: String?
    }

    // MARK: - Wind
    struct Wind: Codable {
        let speed: Double?
        let deg: Int?
        let gust: Double?
    }

}

struct RelaxedString: Codable {
    var value: String
    
    init(_ value: String) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        // attempt to decode from all JSON primitives
        if let str = try? container.decode(String.self) {
            value = str
        } else if let int = try? container.decode(Int.self) {
            value = int.description
        } else if let double = try? container.decode(Double.self) {
            value = double.description
        } else if let bool = try? container.decode(Bool.self) {
            value = bool.description
        } else {
            throw DecodingError.typeMismatch(String.self, .init(codingPath: decoder.codingPath, debugDescription: ""))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
