//
//  PhotoData.swift
//  YourWeather
//
//  Created by Alexander Kovzhut on 02.01.2022.
//

struct PhotoData: Codable {
    let description: String?
    let urls: URLS
    let location: Location
    let user: User
}

struct Location: Codable {
    let name: String?
}

struct User: Codable {
    let name: String?
}

struct URLS: Codable {
    let regular: String?
}
