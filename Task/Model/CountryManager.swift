//
//  CountryManager.swift
//  Task
//
//  Created by Sai Balaji on 13/01/24.
//

import Foundation

//Reads the Country JSON file decodes it 
public final class CountryManager {
    public static let shared = CountryManager()
    private init() {}

    public var localeIdentifier: String = NSLocale.current.identifier

   
    public func getCountries() -> [Country] {
        guard let path = Bundle.main.path(forResource: "countries", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return [] 
        }
        return (try? JSONDecoder().decode([Country].self, from: data)) ?? []
    }
}
