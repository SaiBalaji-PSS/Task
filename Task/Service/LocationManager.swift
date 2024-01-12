//
//  LocationManager.swift
//  Task
//
//  Created by Sai Balaji on 11/01/24.
//

import Foundation
import CoreLocation
import UIKit


protocol LocationManagerDelegate: AnyObject{
    func didUpdateLocation(location: CLLocation)
    func didFailToUpdateLocation(error: Error?,message: String?)
 
}

class LocationManager: NSObject{
    static var shared = LocationManager()
    weak var delegate: LocationManagerDelegate?
    
    lazy var geocoder = CLGeocoder()
    private lazy var locationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    func configureLocationManager(){
        let status = locationManager.authorizationStatus
        switch status{
        case .authorizedAlways:
            locationManager.requestLocation()
            break
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            
            delegate?.didFailToUpdateLocation(error: nil, message: "Unable to get current location change the privacy settings")
            break
        case .denied:
            
            delegate?.didFailToUpdateLocation(error: nil, message: "Unable to get current location change the privacy settings")
            break
        @unknown default:
            break
            
        }
    }
    
    func refreshUserLocation(){
        self.configureLocationManager()
    }
    
//    func reverseGeocodeCoordinates(latitude: Double,longitude: Double,onCompletion:@escaping(CLPlacemark?,Error?)->(Void)){
//        print("CURRENT LOCALE \(Locale.current)")
//        geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude),preferredLocale: Locale.init(identifier: String(Constants.CURRENT_DEVICE_LANGUAGE_ID))) { placemarks , error  in
//            if let error{
//                print(error)
//                onCompletion(nil,error)
//            }
//            if let placemark = placemarks?.first{
//                print(placemark)
//                onCompletion(placemark,error)
//            }
//        }
//    }
    
}


extension LocationManager: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.configureLocationManager()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            delegate?.didUpdateLocation(location: location)
            manager.stopUpdatingLocation()
        }
        else{
            
            delegate?.didFailToUpdateLocation(error: nil, message: "Unable to get current location")
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailToUpdateLocation(error: error, message: nil)
        locationManager.requestWhenInUseAuthorization()
    }
}
