//
//  Extensions.swift
//  Task
//
//  Created by Sai Balaji on 13/01/24.
//

import Foundation

extension DateFormatter{
    static func getFormatterForecastDate(dateString: String?) -> String?{
        if let dateString{
            //dd-MM-yyyy HH:mm:ss
            let inputDateFormatter = DateFormatter()
            inputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let inputDate = inputDateFormatter.date(from: dateString)
            if let inputDate{
                let outputDateFormatter = DateFormatter()
                outputDateFormatter.dateFormat = "dd/MM/yyyy"
                return outputDateFormatter.string(from: inputDate)
            }
        }
        return nil
    }
}
