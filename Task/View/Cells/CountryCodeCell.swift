//
//  CountryCodeCell.swift
//  Task
//
//  Created by Sai Balaji on 13/01/24.
//

import UIKit

class CountryCodeCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var flagLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCell(isoCode: String,countryName: String){
        self.flagLbl.text = isoCode.getFlag()
        self.titleLbl.text = countryName
    }
}


public extension String {
    /// Returns String unicode value of country flag for iso code
    func getFlag() -> String {
        unicodeScalars
            .map { 127_397 + $0.value }
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
}
