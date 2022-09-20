//
//  WeatherManager.swift
//  Clima
//
//  Created by Srikant Das on 01/03/2022
//

import Foundation
import CoreLocation

class WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1af844da7f264c0f53bf3578cffee89c&units=metric"
    var delegate : WeatherManagerDelegate?
    func fetchWeather(city:String){
        let url = "\(self.weatherURL)&q=\(city)"
        self.performRequest(withURL: url)
        
    }
    
    func performRequest(withURL urlString:String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let data = data,let model = self.parseJSON(weatherData: data){
                    self.delegate?.didUpdateWeather(weather: model)
                }else if let error = error{
                    self.delegate?.didFail(error: error)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData:Data)->WeatherModel?{
        let decoder = JSONDecoder()
        do{
             let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather.first?.id ?? 0
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        }catch{
            self.delegate?.didFail(error: error)
            return nil
        }
       
    }
    
    func fetchWeather(_ lattutude: CLLocationDegrees,_ longitude: CLLocationDegrees){
        let urlString = "\(self.weatherURL)&lat=\(lattutude)&lon=\(longitude)"
        self.performRequest(withURL: urlString)
    }

}

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather:WeatherModel)
    func didFail(error:Error)
}
