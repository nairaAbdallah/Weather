//
//  WeatherData.swift
//  Weather
//
//  Created by Naira Bassam on 20/08/2021.
//

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
