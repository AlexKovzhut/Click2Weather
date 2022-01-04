//
//  WeatherNetworkLayer.swift
//  YourWeather
//
//  Created by Alexander Kovzhut on 04.01.2022.
//

import CoreLocation

enum WeatherServiceError: Error {
    case network(statusCode: Int)
    case parsing
    case general(reason: String)
}

protocol WeatherServiceDelegate: AnyObject {
    func didFetchWeather(_ weatherService: WeatherNetworkLayer, _ weather: WeatherModel)
    func didFailWithError(_ weatherService: WeatherNetworkLayer, _ error: WeatherServiceError)
}

struct WeatherNetworkLayer {
    static let shared = WeatherNetworkLayer()
    
    var delegate: WeatherServiceDelegate?

    let weatherURL = "http://api.openweathermap.org/data/2.5/weather?appid=98968b07c1dd9f318c47c889e6b070ec&units=metric&lang=en"

    func fetchWeather(cityName: String) {
        guard let urlEncodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            assertionFailure("Could not encode city named: \(cityName)")
            return
        }

        let urlString = "\(weatherURL)&q=\(urlEncodedCityName)"
        performRequest(with: urlString)
    }

    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {
        // Create a URL
        let url = URL(string: urlString)!
        // Create a URLSession
        let session = URLSession(configuration: .default)
        // Give the session a task
        let task = session.dataTask(with: url) {data, responce, error in

            guard let unwrapedData = data, let httpResponce = responce as? HTTPURLResponse else {
                return
            }

            guard error == nil else {
                DispatchQueue.main.async {
                    let generalError = WeatherServiceError.general(reason: "Check network availability")
                    self.delegate?.didFailWithError(self, generalError)
                }
                return
            }

            guard (200...299).contains(httpResponce.statusCode) else {
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(self, WeatherServiceError.network(statusCode: httpResponce.statusCode))
                }
                return
            }

            guard let weather = self.parseJSON(unwrapedData) else { return }

            DispatchQueue.main.async {
                self.delegate?.didFetchWeather(self, weather)
            }
        }
        //Start the task
        task.resume()
    }

    private func parseJSON(_ weatherData: Data) -> WeatherModel? {
        guard let decodedData = try? JSONDecoder().decode(WeatherData.self, from: weatherData) else {
            DispatchQueue.main.async {
                self.delegate?.didFailWithError(self, WeatherServiceError.parsing)
            }
            return nil
        }

        let dayTime = decodedData.dt
        let timezone = decodedData.timezone
        let id = decodedData.weather[0].id
        let temperature = decodedData.main.temp
        let cityName = decodedData.name
        let countryName = decodedData.sys.country
        let mainDescription = decodedData.weather[0].main
        let tempMax = decodedData.main.temp_max
        let tempMin = decodedData.main.temp_min
        let tempFeelsLike = decodedData.main.feels_like
        let windSpeed = decodedData.wind.speed
        let windDegrees = decodedData.wind.deg
        let pressure = decodedData.main.pressure
        let humidity = decodedData.main.humidity
        let visibility = decodedData.visibility

        let weather = WeatherModel(
            dayTime: dayTime,
            timezone: timezone,
            cityName: cityName,
            countryName: countryName,
            conditionId: id,
            temperature: temperature,
            mainDescription: mainDescription,
            tempMax: tempMax,
            tempMin: tempMin,
            tempFeelsLike: tempFeelsLike,
            windSpeed: windSpeed,
            windDegrees: windDegrees,
            pressure: pressure,
            humidity: humidity,
            visibility: visibility
        )

        return weather
    }
}
