//
//  User.swift
//  AuctionAppDemo
//
//  Created by student on 5/22/25.
//

import Foundation

struct Geo: Codable {
    let lat: String?
    let lng: String?
}

struct Address: Codable {
    let city: String?
    let geo: Geo?
    let street: String?
    let suite: String?
    let zipcode: String?
}

struct Company: Codable {
    let bs: String?
    let catchPhrase: String?
    let name: String?
}

struct User: Codable {
    let address: Address?
    let company: Company?
    let email: String?
    let id: Int
    let name: String?
    let phone: String?
    let username: String?
    let website: String?
}
