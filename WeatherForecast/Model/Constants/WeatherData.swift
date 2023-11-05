//
//  WeatherData.swift
//  WeatherForecast
//
//  Created by Абдулла-Бек on 24/10/23.
//

import Foundation

struct WeatherData: Codable {
    let sys: Sys
    let name: String
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let coord: Coord
}

struct Sys: Codable {
    let country: String
}

struct Main: Codable {
    let temp: Double
}

struct Wind: Codable {
    let speed: Double
}

struct Clouds: Codable {
    let all: Int
}

struct Coord: Codable {
    let lat: Double
    let lon: Double
}

struct SearchResponse: Codable {
    let list: [City]
}

struct City: Codable {
    let name: String
}
