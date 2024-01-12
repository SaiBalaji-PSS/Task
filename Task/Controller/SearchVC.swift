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
    weak var delegate: ForecastSearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchTextField.textField.delegate = self
    }
    
    func getWeatherForecastData(searchQuery: String?){
        if let searchQuery{
            Task{
                let result = await NetworkService().sendGetRequest(url: Constants.BASE_URL + Constants.FORE_CAST_QUERY + "q=\(searchQuery)&cnt=40" + Constants.API_KEY_QUERTY + "&units=metric" + Constants.LANGUADE_CODE_QUERY, type: ForecastModel.ForecastModelResponse.self)
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

}


extension SearchVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text)
        self.getWeatherForecastData(searchQuery: textField.text)
        return true
    }
    
}
