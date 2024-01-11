//
//  ViewController.swift
//  Task
//
//  Created by Sai Balaji on 11/01/24.
//

import UIKit
import CoreLocation


class CurrentLocationWeatherVC: UIViewController {

    //MARK: - PROPERTIES
    private var locationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureLocationManager()

    }

    
    //MARK: - HELPERS
    func configureLocationManager(){
        locationManager.configureLocationManager()
        locationManager.delegate = self
        
        
    }
    
    func showMessage(title:String?,message: String?){
        let alertVC = UIAlertController(title: title ?? "", message: message ?? "", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alertVC, animated: false)
    }

}



extension  CurrentLocationWeatherVC: LocationManagerDelegate{
    
    func didUpdateLocation(location: CLLocation) {
        print("LATITUDE \(location.coordinate.latitude)")
        print("LONGITUDE \(location.coordinate.longitude)")
        
    }
    func didFailToUpdateLocation(error: Error?, message: String?) {
        if let message{
            print(message)
            self.showMessage(title: "Info", message: message)
        }
        if let error{
            print(error)
            self.showMessage(title: "Error", message: error.localizedDescription)
        }
    }
}
