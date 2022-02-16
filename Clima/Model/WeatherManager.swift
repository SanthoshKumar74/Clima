//
//  WeatherManager.swift
//  Clima
//
//  Created by Santhosh Kumar on 04/12/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
struct WeatherManager{
    let apistring = "https://api.openweathermap.org/data/2.5/weather?appid=366eb1f606047055e57318a1bba0b239&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func getWeather(cityname: String){
        let urlString = "\(apistring)&q=\(cityname)"
        performTask(with:urlString)
    }
    func getWeather(_ latitude: CLLocationDegrees,_ longititude: CLLocationDegrees){
        let urlString = "\(apistring)&lat=\(latitude)&lon=\(longititude)"
        performTask(with: urlString)
        
    }
    func performTask(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    delegate?.handleErrors(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = parseJSON(safeData){
                        delegate?.didUpdateWeather(self,weather: weather)
                        
                    }}}
                task.resume()
        }
        
        func parseJSON(_ weatherdata: Data)-> WeatherModel?{
            let decoder = JSONDecoder()
            
            do{let decodedData = try decoder.decode(WeatherData.self, from: weatherdata)
                let id = decodedData.weather[0].id
                let name = decodedData.name
                let temperature = decodedData.main.temp
                let description = decodedData.weather[0].description
                let weatherModel = WeatherModel(name: name, temperature: temperature, conditionId: id, description: description)
                return weatherModel
            }
            catch{
                delegate?.handleErrors(error: error)
                return nil
            }}
        
        
        
        
    }
}
protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherMaanager:WeatherManager, weather: WeatherModel)
    func handleErrors(error: Error)
    
}

