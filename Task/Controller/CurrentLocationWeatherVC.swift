//
//  ViewController.swift
//  Task
//
//  Created by Sai Balaji on 11/01/24.
//

import UIKit
import CoreLocation
import SDWebImage

class CurrentLocationWeatherVC: UIViewController {

    //MARK: - PROPERTIES
    private var locationManager = LocationManager()
    
    @IBOutlet weak var currentTemperatureLable: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var highLowTemperatureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    //MARK: - LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureLocationManager()

    }
    
    
    
    
    
    
    @IBAction func refreshBtnPressed(_ sender: Any) {
        locationManager.configureLocationManager()
    }
    
    
    
    

    
    //MARK: - HELPERS
    func configureLocationManager(){
        locationManager.configureLocationManager()
        locationManager.delegate = self
        navigationItem.title = "Current Weather"
    }
    
    func getCurrentWeather(latitude: String,longitude: String){
        Task{
            let result  = await NetworkService().sendGetRequest(url: Constants.BASE_URL + "weather?lat=\(latitude)&lon=\(longitude)" + Constants.API_KEY_QUERTY + "&units=metric" + Constants.LANGUADE_CODE_QUERY , type: CurrentWeatherModel.self)
            switch result{
                case .success(let response):
                   // print(response)
                    if let currentTemperature = response.main?.temp{
                        self.currentTemperatureLable.text = "\(currentTemperature)°"
                    }
                    if let currentWeather = response.weather?.first?.main{
                        self.currentWeatherLabel.text = "\(currentWeather)"
                    }
                    if let minTemp = response.main?.tempMin, let maxTemp = response.main?.tempMax{
                        self.highLowTemperatureLabel.text = "Low: \(minTemp)° High: \(maxTemp)°"
                    }
                if let windSpeed = response.wind?.speed{
                    self.windSpeedLabel.text = "Wind Speed: \(windSpeed) m/s"
                    
                }
                if let humidity = response.main?.humidity{
                    self.humidityLabel.text = "Humidity: \(humidity) %"
                }
                if let visibility = response.visibility{
                    self.visibilityLabel.text = "Visibility: \(visibility) m"
                }
                if let weatherDescription = response.weather?.first?.description{
                    self.weatherDescriptionLabel.text = weatherDescription
                }
                if let weatherIcon = response.weather?.first?.icon{
                    self.weatherIconImageView.sd_setImage(with: URL(string: "\(Constants.WEATHER_ICON_URL)\(weatherIcon)@2x.png"))
                }
                    break
                case .failure(let error):
                    print(error)
                    self.showMessage(title: "Error", message: error.localizedDescription)
                    break
            }
        }
    }
    
    func getCurrentLocationAddress(lat: Double,long: Double){
        locationManager.reverseGeocodeCoordinates(latitude: lat, longitude: long) { placemark , error  in
            if let error{
                print(error)
                self.showMessage(title: "Error", message: error.localizedDescription)
            }
            if let placemark{
                self.currentLocationLabel.text = "\(placemark.name ?? "")  \(placemark.administrativeArea ?? "")"
                
            }
        }
    }
    
    func showMessage(title:String?,message: String?){
        let alertVC = UIAlertController(title: title ?? "", message: message ?? "", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alertVC, animated: false)
    }

}


//MARK: - LOCATION MANAGER DELEGATE METHODS
extension  CurrentLocationWeatherVC: LocationManagerDelegate{
    
    func didUpdateLocation(location: CLLocation) {
        print("LATITUDE \(location.coordinate.latitude)")
        print("LONGITUDE \(location.coordinate.longitude)")
        self.getCurrentWeather(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)")
        self.getCurrentLocationAddress(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        
        
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
