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
