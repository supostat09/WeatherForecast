//
//  WeatherService.swift
//  WeatherForecast
//
//  Created by Абдулла-Бек on 24/10/23.
//

import Foundation

class WeatherService {
    
    let apiKey = "5232df7c6b5387abf9b3c46b6b7bbd75"

    func getWeatherData(forCity city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
            // Создайте URL-адрес и URLRequest для запроса данных о погоде по названию города
            let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
            
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    if let data = data {
                        do {
                            let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                            completion(.success(weatherData))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }.resume()
            }
        }
    }

