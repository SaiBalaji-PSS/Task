//
//  CustomCountryCodePicker.swift
//  Task
//
//  Created by Sai Balaji on 13/01/24.
//

import UIKit

protocol CustomCountryPickerDelegate: AnyObject{
    func didPickCountry(name: String?,isoCode: String?)
}
class CustomCountryCodePicker: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: CustomCountryPickerDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "CustomCountryCodePicker", bundle: Bundle(for: CustomCountryCodePicker.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CountryCodeCell", bundle: nil), forCellReuseIdentifier: "CountryCodeCell")
    }


    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    func show(){
        if #available(iOS 13, *){
            UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true)
        }
        else{
            UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true)
        }
    }
    
   
}


extension CustomCountryCodePicker: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CountryManager.shared.getCountries().count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell", for: indexPath) as? CountryCodeCell{
            cell.updateCell(isoCode: CountryManager.shared.getCountries()[indexPath.row].isoCode, countryName: CountryManager.shared.getCountries()[indexPath.row].name)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didPickCountry(name: CountryManager.shared.getCountries()[indexPath.row].name, isoCode: CountryManager.shared.getCountries()[indexPath.row].isoCode)
        self.dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}
