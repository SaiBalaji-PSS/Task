//
//  SearchVC.swift
//  Task
//
//  Created by Sai Balaji on 12/01/24.
//

import UIKit



//DELEGATE METHOD TO SEND FORECAST API REPOSNE TO CURRENT WEATHER SCREEN
protocol ForecastSearchDelegate: AnyObject{
    func didSearchComplete(response: ForecastModel.ForecastModelResponse)
}
class SearchVC: BaseViewController {

    //MARK: - PROPERTIES
    private var selectedCountryCode: String?
    weak var delegate: ForecastSearchDelegate?
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var searchTextField: CustomTextField!
    @IBOutlet weak var countryCodeTextField: CustomTextField!
    @IBOutlet weak var getWeatherBtn: UIButton!
   
    //MARK: - LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - HELPERS
    func configureUI(){
        searchTextField.textField.placeholder = "City Name"
        searchTextField.textField.layer.borderColor = UIColor(named: "CustomBorderColor")?.cgColor
        searchTextField.leftIcon.image = UIImage(systemName: "building.2")
        searchTextField.leftIcon.tintColor = UIColor(named: "CustomBorderColor")
        countryCodeTextField.textField.placeholder = "Country Code"
        countryCodeTextField.leftIcon.image = UIImage(systemName: "globe.europe.africa")
        countryCodeTextField.leftIcon.tintColor = UIColor(named: "CustomBorderColor")
        searchTextField.textField.delegate = self
        countryCodeTextField.textField.delegate = self
        countryCodeTextField.textField.isEnabled = false
        countryCodeTextField.isUserInteractionEnabled = true
        countryCodeTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
        getWeatherBtn.layer.borderColor = UIColor(named: "CustomBorderColor")?.cgColor
        getWeatherBtn.layer.borderWidth = 1
    }
    
    //Change TextField border color based on current device theme
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       if #available(iOS 13.0, *) {
           if previousTraitCollection?.userInterfaceStyle == .dark{
    
             
               self.countryCodeTextField.layer.borderColor = UIColor.darkGray.cgColor
               self.countryCodeTextField.layer.borderWidth = 1
               self.searchTextField.layer.borderColor = UIColor.darkGray.cgColor
               self.searchTextField.layer.borderWidth = 1
               self.getWeatherBtn.layer.borderColor = UIColor.darkGray.cgColor
               self.getWeatherBtn.layer.borderWidth = 1
               
           }
           else{
       
               self.countryCodeTextField.layer.borderColor = UIColor.white.cgColor
               self.countryCodeTextField.layer.borderWidth = 1
               self.searchTextField.layer.borderColor = UIColor.white.cgColor
               self.searchTextField.layer.borderWidth = 1
               self.getWeatherBtn.layer.borderColor = UIColor.white.cgColor
               self.getWeatherBtn.layer.borderWidth = 1
           }
         
       }
    }
    
    
    
    
    
    @objc func tapped(_ recognizer: UITapGestureRecognizer){
        let countryCodePickerView = CustomCountryCodePicker()
        countryCodePickerView.delegate = self
        countryCodePickerView.show()
    }
    
    //MARK: - IBACTION
    @IBAction func getWeatherBtnPressed(_ sender: Any) {
            self.getWeatherForecastData(cityName: searchTextField.textField.text,countryCode: countryCodeTextField.textField.text)
    }

}



//MARK: - API CALL TO GET WEATHER FORECAST DATA FOR GIVEN CITY NAME OR COUNTRY CODE
extension SearchVC{
    func getWeatherForecastData(cityName: String?,countryCode: String?){
      
            Task{
                let result = await NetworkService().sendGetRequest(url: Constants.BASE_URL + Constants.FORE_CAST_QUERY + "q=\(cityName ?? ""),\(self.selectedCountryCode ?? "")&cnt=40" + Constants.API_KEY_QUERTY + "&units=metric" + Constants.LANGUADE_CODE_QUERY, type: ForecastModel.ForecastModelResponse.self)
               
                switch result{
                    case .success(let response):
                        print(response)
                    if let messageCode = response.messageString{
                        if messageCode != "0"{
                            let _ =   self.showAlert(title: "Info", message: response.messageString?.uppercased() ?? "", isAction: false)
                            return
                        }
                    }
                    self.delegate?.didSearchComplete(response: response)
                    self.navigationController?.popViewController(animated: true)
                        break
                    case .failure(let error):
                        print(error)
                   let _ = self.showAlert(title: "Error", message: error.localizedDescription, isAction: false)
                        break
                        
                }
                
            }
        
        
    }
}


//MARK: - UITEXTFIELD DELEGATE TO END EDITING
extension SearchVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
      
    }
}


//MARK: - CUSTOM COUNTRY PICKER DELGATE METHODS
extension SearchVC: CustomCountryPickerDelegate{
    func didPickCountry(name: String?, isoCode: String?) {
        if let isoCode, let name{
            self.countryCodeTextField.textField.text = "\(isoCode.getFlag()) \(name)"
            self.selectedCountryCode = isoCode
        }
        
    }
}
