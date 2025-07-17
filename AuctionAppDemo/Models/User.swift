//
//  User.swift
//  AuctionAppDemo
//
//  Created by student on 5/22/25.
//

import Foundation

struct Geo: Codable {
    var lat: String?
    var lng: String?
}

struct Address: Codable {
    var city: String?
    var geo: Geo?
    var street: String?
    var suite: String?
    var zipcode: String?
}

struct Company: Codable {
    var bs: String?
    var catchPhrase: String?
    var name: String?
}

struct User: Codable {
    var address: Address?
    var company: Company?
    var email: String?
    var id: Int
    var name: String?
    var phone: String?
    var username: String?
    var website: String?
}

func emptyUser() -> User {
    return User(address: Address(city: nil, geo: Geo(lat: nil, lng: nil),
                                 street: nil, suite: nil, zipcode: nil),
                company: Company(bs: nil, catchPhrase: nil, name: nil),
                email: nil, id: 0, name: nil, phone: nil, username: nil, website: nil)
}

func validateEmail(with email: String) -> Bool {
    let emailRegex = "\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\b"
    let emailPred = NSPredicate(format:"SELF MATCHES[c] %@", emailRegex)
    
    return emailPred.evaluate(with: email)
}

// This can be much further expanded
func validateUser(with user: User, completion: @escaping (Bool, String, String) -> Void) {
    if user.name == nil || user.name!.isEmpty {
        completion(false, "Invalid Name", "Name cannot be empty")
    } else if user.username == nil || user.username!.isEmpty {
        completion(false, "Invalid Username", "Username cannot be empty")
    } else if validateEmail(with: user.email ?? "") == false {
        completion(false, "Invalid Email", "Please check email address")
    } else {
        completion(true, "Please report this", "This is a bug")
    }
}
