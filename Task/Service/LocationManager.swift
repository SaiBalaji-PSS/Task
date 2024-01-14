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
            locationManager.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
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
    
    
}



//MARK: - CLOCATION MANAGER DELEGATE FOR GETTING CURRENT USER LOCATION AND PERFORMING GEOFENCING WHEN USER EXITS THE REGION
extension LocationManager: CLLocationManagerDelegate{
    
    //If user exits the region then automatically fetch the latest current user location
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        self.configureLocationManager()
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.configureLocationManager()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            let geofenceRegionCenter = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 100, identifier: "ID")
            geofenceRegion.notifyOnExit = true
            locationManager.startMonitoring(for: geofenceRegion)
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
