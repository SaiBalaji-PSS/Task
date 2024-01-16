//
//  CustomTextField.swift
//  Task
//
//  Created by Sai Balaji on 12/01/24.
//

import UIKit

@IBDesignable
class CustomTextField: UIView {

     var leftIcon: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
     var textField: UITextField = {
        var textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configureUI()
    }
    

    
    func configureUI(){
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor(named: "CustomBorderColor")?.cgColor
        self.layer.borderWidth = 1
        self.addSubview(leftIcon)
        leftIcon.image = UIImage(systemName: "magnifyingglass")
        leftIcon.tintColor = UIColor.white
        leftIcon.translatesAutoresizingMaskIntoConstraints = false
        leftIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        leftIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        leftIcon.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor,constant: 8).isActive = true
        leftIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        
        self.addSubview(textField)
        textField.placeholder = "Enter location"
        textField.keyboardType = .webSearch
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: leftIcon.rightAnchor,constant: 8).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        
    }
    
    

}
