//
//  CountryModel.swift
//  Task
//
//  Created by Sai Balaji on 13/01/24.
//

import Foundation



public struct Country: Codable {
    public var name: String
    public let isoCode: String

    public init(phoneCode: String, isoCode: String) {
        self.name = phoneCode
        self.isoCode = isoCode
    }
    
    public init(isoCode: String) {
        self.isoCode = isoCode
        self.name = ""
        if let country = CountryManager.shared.getCountries().first(where: { $0.isoCode == isoCode }) {
            self.name = country.name
        }
    }
}

public extension Country {
    /// Returns localized country name for localeIdentifier
    var localizedName: String {
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: isoCode])
        let name = NSLocale(localeIdentifier: CountryManager.shared.localeIdentifier)
            .displayName(forKey: NSLocale.Key.identifier, value: id) ?? isoCode
        return name
    }
}
