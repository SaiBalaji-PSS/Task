//
//  ForecastCell.swift
//  Task
//
//  Created by Sai Balaji on 11/01/24.
//

import UIKit

class ForecastCell: UICollectionViewCell {

   
    
    @IBOutlet weak var weatherIconLbl: UIImageView!
    @IBOutlet weak var weatherDescriptionLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(weatherIcon: String?,temp: Double?,weatherDescription: String?,date: String?){
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.borderWidth = 1
        if let weatherIcon{
            self.weatherIconLbl.sd_setImage(with: URL(string: "\(Constants.WEATHER_ICON_URL)\(weatherIcon)@2x.png"),placeholderImage: UIImage(named: "noweather"))
        }
        if let temp{
            self.tempLbl.text = "\(temp)°"
        }
        if let weatherDescription{
            self.weatherDescriptionLbl.text = weatherDescription
        }
        if let date{            if let formattedDate = DateFormatter.getFormatterForecastDate(dateString: date){
                self.dateLbl.text = formattedDate
            }
            
        }
    }
}
