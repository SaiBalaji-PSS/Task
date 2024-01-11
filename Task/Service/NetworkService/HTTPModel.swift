//
//  HTTPModel.swift
//  Task
//
//  Created by Sai Balaji on 11/01/24.
//

import Foundation

enum HTTPMethods: String{
    case GET = "GET"
    var method: String{
        get{
            return rawValue
        }
    }
}

enum HTTPError: Error{
    case failedResponse
    case failedDecoding
    case invalidUrl
    case invalidData
}
