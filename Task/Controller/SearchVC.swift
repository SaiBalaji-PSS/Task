//
//  SearchVC.swift
//  Task
//
//  Created by Sai Balaji on 12/01/24.
//

import UIKit

protocol ForecastSearchDelegate: AnyObject{
    func didSearchComplete(response: ForecastModel.ForecastModelResponse)
}
class SearchVC: BaseViewController {

    @IBOutlet weak var searchTextField: CustomTextField!
  
    @IBOutlet weak var countryCodeTextField: CustomTextField!
    private var selectedCountryCode: String?
    
    @IBOutlet weak var getWeatherBtn: UIButton!
    weak var delegate: ForecastSearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       if #available(iOS 13.0, *) {
           if previousTraitCollection?.userInterfaceStyle == .dark{
               print("DARK")
             
               self.countryCodeTextField.layer.borderColor = UIColor.darkGray.cgColor
               self.countryCodeTextField.layer.borderWidth = 1
               self.searchTextField.layer.borderColor = UIColor.darkGray.cgColor
               self.searchTextField.layer.borderWidth = 1
               self.getWeatherBtn.layer.borderColor = UIColor.darkGray.cgColor
               self.getWeatherBtn.layer.borderWidth = 1
               
           }
           else{
               print("LIGHT")
               self.countryCodeTextField.layer.borderColor = UIColor.white.cgColor
               self.countryCodeTextField.layer.borderWidth = 1
               self.searchTextField.layer.borderColor = UIColor.white.cgColor
               self.searchTextField.layer.borderWidth = 1
               self.getWeatherBtn.layer.borderColor = UIColor.white.cgColor
               self.getWeatherBtn.layer.borderWidth = 1
           }
         
       }
    }
    
    
  
    
    
    
    
    
    
    
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
    
    
    
    
    
    @objc func tapped(_ recognizer: UITapGestureRecognizer){
        print("TAPPED")
        let countryCodePickerView = CustomCountryCodePicker()
        countryCodePickerView.delegate = self
        countryCodePickerView.show()
    }
    
    
    @IBAction func getWeatherBtnPressed(_ sender: Any) {
      
        
            self.getWeatherForecastData(cityName: searchTextField.textField.text,countryCode: countryCodeTextField.textField.text)
        
   
    }
    
    
    
    
    
    
    
    
    
    
    
    func getWeatherForecastData(cityName: String?,countryCode: String?){
      
            Task{
                let result = await NetworkService().sendGetRequest(url: Constants.BASE_URL + Constants.FORE_CAST_QUERY + "q=\(cityName ?? ""),\(self.selectedCountryCode ?? "")&cnt=40" + Constants.API_KEY_QUERTY + "&units=metric" + Constants.LANGUADE_CODE_QUERY, type: ForecastModel.ForecastModelResponse.self)
                var i = 0
                switch result{
                    case .success(let response):
                        print(response)
                    if let messageCode = response.messageString{
                        if messageCode != "0"{
                            self.showAlert(title: "Info", message: response.messageString?.uppercased() ?? "")
                            return
                        }
                    }
                    self.delegate?.didSearchComplete(response: response)
                    self.navigationController?.popViewController(animated: true)
                        break
                    case .failure(let error):
                        print(error)
                     self.showAlert(title: "Error", message: error.localizedDescription)
                        break
                        
                }
                
            }
        
        
    }

}


extension SearchVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
      
    }
    
}



extension SearchVC: CustomCountryPickerDelegate{
    func didPickCountry(name: String?, isoCode: String?) {
        if let isoCode, let name{
            self.countryCodeTextField.textField.text = "\(isoCode.getFlag()) \(name)"
            self.selectedCountryCode = isoCode
        }
        
    }
}
