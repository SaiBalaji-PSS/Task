//
//  BaseViewController.swift
//  Task
//
//  Created by Sai Balaji on 13/01/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showAlert(title: String?,message: String?,isAction: Bool) -> UIAlertController?{
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if isAction{
            return alertVC
        }
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alertVC, animated: true)
        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
