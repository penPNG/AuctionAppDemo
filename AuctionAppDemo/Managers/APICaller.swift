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
        
        #if DEBUG
        print("before")
        #endif
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            #if DEBUG
            print(error?.localizedDescription ?? "")
            #endif
            guard let data = data, error == nil else {
                #if DEBUG
                print("No Data Received")
                #endif
                return
            }
            
            do {
                //let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                let results = try JSONDecoder().decode([User].self, from: data)
                completion(.success(results))
            } catch {
                #if DEBUG
                print(error.localizedDescription)
                #endif
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
