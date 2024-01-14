//
//  ViewController.swift
//  Task
//
//  Created by Sai Balaji on 11/01/24.
//

import UIKit
import CoreLocation
import SDWebImage

class CurrentLocationWeatherVC: BaseViewController {

    //MARK: - PROPERTIES
    private var locationManager = LocationManager()
    private var fiveDaysForecastData = [ForecastModel.List]()
   
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var currentTemperatureLable: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var highLowTemperatureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    //MARK: - LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureLocationManager()
        collectionView.register(UINib(nibName: "ForecastCell", bundle: nil), forCellWithReuseIdentifier: "ForecastCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    //MARK: - IBACTIONS
    @IBAction func searchBtnPressed(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as? SearchVC{
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
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

}




//MARK: - API CALLS
extension CurrentLocationWeatherVC{
    func getFiveDaysForecast(latitude: String,longitude: String){
        Task{
            let result = await NetworkService().sendGetRequest(url: Constants.BASE_URL + "forecast?lat=\(latitude)&lon=\(longitude)" + Constants.API_KEY_QUERTY + "&units=metric" + Constants.LANGUADE_CODE_QUERY, type: ForecastModel.ForecastModelResponse.self)
            switch result{
                case .success(let response):
                    print(response)
                    if let messageCode = response.messageString{
                    if messageCode != "0"{
                        self.showAlert(title: "Info", message: response.messageString?.uppercased() ?? "", isAction: false)
                        return
                    }
                    }
                  //  print(Constants.BASE_URL + "forecast?lat=\(latitude)&lon=\(longitude)" + Constants.API_KEY_QUERTY + "&units=metric" + Constants.LANGUADE_CODE_QUERY)
                    
                    if let city = response.city?.name{
                        self.currentLocationLabel.text = city
                    }
                    if let data = response.list{
                       // self.fiveDaysForecastData = data
                        self.getOnlyFiveDaysForecast(data: data)
                       // self.collectionView.reloadData()
                    }
                    break
                case .failure(let error):
                    print(error)
                self.showAlert(title: "Error", message: error.localizedDescription, isAction: false)
                    break
            }
        }
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
               
                if let weatherDescription = response.weather?.first?.description{
                    self.weatherDescriptionLabel.text = weatherDescription
                }
                if let weatherIcon = response.weather?.first?.icon{
                    self.weatherIconImageView.sd_setImage(with: URL(string: "\(Constants.WEATHER_ICON_URL)\(weatherIcon)@2x.png"))
                }
           
                    break
                case .failure(let error):
                    print(error)
                self.showAlert(title: "Error", message: error.localizedDescription, isAction: false)
                    break
            }
        }
    }
    
 
    
    func getOnlyFiveDaysForecast(data: [ForecastModel.List]){
        self.fiveDaysForecastData.removeAll()
        var currentIndex = 0
        while(currentIndex != data.count){
           
            self.fiveDaysForecastData.append(data[currentIndex])
            currentIndex = currentIndex + 8
        }
        self.collectionView.reloadData()
    }
    
}


//MARK: - LOCATION MANAGER DELEGATE METHODS
extension  CurrentLocationWeatherVC: LocationManagerDelegate{
    
    func didUpdateLocation(location: CLLocation) {
        print("LATITUDE \(location.coordinate.latitude)")
        print("LONGITUDE \(location.coordinate.longitude)")
        self.getCurrentWeather(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)")
        self.getFiveDaysForecast(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)")
      
        
        
    }
    func didFailToUpdateLocation(error: Error?, message: String?) {
        if let message{
            print(message)
            if let avc = self.showAlert(title: "Info", message: message, isAction: true){
                avc.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
                    if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
                    }
                }))
                self.present(avc, animated: true)
            }
           
        }
        if let error{
            print(error)
            self.showAlert(title: "Error", message: error.localizedDescription, isAction: false)
        }
    }
}


//MARK: - FORECAST COLLECTION VIEW DELEGATES
extension CurrentLocationWeatherVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fiveDaysForecastData.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 180)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCell", for: indexPath) as? ForecastCell{
            cell.updateCell(weatherIcon: self.fiveDaysForecastData[indexPath.item].weather?.first?.icon, temp: self.fiveDaysForecastData[indexPath.item].main?.temp, weatherDescription: self.fiveDaysForecastData[indexPath.item].weather?.first?.main,date: self.fiveDaysForecastData[indexPath.item].dtTxt)
            return cell
        }
        return UICollectionViewCell()
    }
}





//MARK: - CURRENT LOCATION DELEGATE

extension CurrentLocationWeatherVC: ForecastSearchDelegate{
    func didSearchComplete(response: ForecastModel.ForecastModelResponse) {
        if let city = response.city?.name{
            self.currentLocationLabel.text = city
        }
        if let data = response.list{
            self.getOnlyFiveDaysForecast(data: data)
        }
        if let latitude = response.city?.coord?.lat, let longitude = response.city?.coord?.lon{
            self.getCurrentWeather(latitude: "\(latitude)", longitude: "\(longitude)")
        }
    }
}

