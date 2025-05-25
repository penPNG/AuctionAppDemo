//
//  APICaller.swift
//  AuctionAppDemo
//
//  Created by student on 5/22/25.
//

import Foundation

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                //print("No Data Received")
                return
            }
            
            do {
                //let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                let results = try JSONDecoder().decode([User].self, from: data)
                //print(results)
                completion(.success(results))
            } catch {
                //print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
