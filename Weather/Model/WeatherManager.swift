//
//  WeatherManager.swift
//  Weather
//
//  Created by Naira Bassam on 19/08/2021.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=bdd95d41fc0d720d0291755e5a968280&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(_ cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        guard let url = URL(string: urlString) else{return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeData = data {
//              let dataString = String(data: safeData, encoding: .utf8)
                guard let weather = self.parseJSON(safeData) else {return}
                self.delegate?.didUpdateWeather(self, weather: weather)
            }
        }
        task.resume()
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
//            weather.conditionName
//            weather.temperatureString
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
