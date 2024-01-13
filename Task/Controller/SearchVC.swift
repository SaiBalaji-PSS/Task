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
class SearchVC: UIViewController {

    @IBOutlet weak var searchTextField: CustomTextField!
    @IBOutlet weak var statecodeTextField: CustomTextField!
    @IBOutlet weak var countryCodeTextField: CustomTextField!
    private var selectedCountryCode: String?
    
    weak var delegate: ForecastSearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchTextField.textField.delegate = self
        statecodeTextField.textField.delegate = self
        countryCodeTextField.textField.delegate = self
        countryCodeTextField.textField.isEnabled = false 
        countryCodeTextField.isUserInteractionEnabled = true
        countryCodeTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
        
    }
    
    @objc func tapped(_ recognizer: UITapGestureRecognizer){
        print("TAPPED")
        let countryCodePickerView = CustomCountryCodePicker()
        countryCodePickerView.delegate = self
        countryCodePickerView.show()
    }
    
    func getWeatherForecastData(cityName: String?,stateCode: String?,countryCode: String?){
      
            Task{
                let result = await NetworkService().sendGetRequest(url: Constants.BASE_URL + Constants.FORE_CAST_QUERY + "q=\(cityName ?? ""),\(stateCode ?? ""),\(self.selectedCountryCode ?? "")&cnt=40" + Constants.API_KEY_QUERTY + "&units=metric" + Constants.LANGUADE_CODE_QUERY, type: ForecastModel.ForecastModelResponse.self)
                var i = 0
                switch result{
                    case .success(let response):
                        print(response)
                    self.delegate?.didSearchComplete(response: response)
                    self.navigationController?.popViewController(animated: true)
                        break
                    case .failure(let error):
                        print(error)
                        break
                        
                }
                
            }
        
        
    }

}


extension SearchVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField.textField || textField == statecodeTextField.textField || textField == countryCodeTextField.textField{
           
            return true
        }
        return false
      
    }
    
}



extension SearchVC: CustomCountryPickerDelegate{
    func didPickCountry(name: String?, isoCode: String?) {
        if let isoCode, let name{
            self.countryCodeTextField.textField.text = "\(isoCode.getFlag()) \(name)"
            self.selectedCountryCode = isoCode
            self.getWeatherForecastData(cityName: searchTextField.textField.text, stateCode: statecodeTextField.textField.text, countryCode: countryCodeTextField.textField.text)
        }
        
    }
}
