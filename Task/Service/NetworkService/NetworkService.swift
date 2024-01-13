//
//  NetworkService.swift
//  Task
//
//  Created by Sai Balaji on 11/01/24.
//

import Foundation

class NetworkService{
    let session = URLSession(configuration: .default)
    
    func sendGetRequest<T: Decodable>(url: String,type: T.Type) async -> Result<T,Error>{
        do{
            guard let url = URL(string: url) else{return .failure(HTTPError.invalidUrl)}
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let (data,response) = try await session.data(for: request)
           // guard let urlResponse = response as? HTTPURLResponse , (200...299).contains(urlResponse.statusCode) else{return .failure(HTTPError.failedResponse)}
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedData)
        }
        catch{
            return .failure(error)
        }
    }
}
