//
//  DataSource.swift
//  Weather
//
//  Created by Denis Zabrovsky on 01.09.2021.
//

import Foundation

protocol DataSource: AnyObject {
    func getDayData(_ dayIndex: Int) -> WeatherDay
    func getHourData(_ dayIndex: Int, _ hourIndex: Int) -> WeatherHour
    func getDaysCount() -> Int
    func getCityName() -> String
    func getCoordinates() -> Coord
}

protocol DataSourceDay: AnyObject {
    func getDayData() -> WeatherDay
    func getHourData(_ hourIndex: Int) -> WeatherHour
}

protocol DataSourceCityList: AnyObject {
    func getCityData(_ index: Int) -> WeatherHour
    func getData() -> [WeatherHour]
}

class WeatherData {
    
    var cityName: String
    var coord: Coord
    var data: [WeatherDay] = []
    
    init(cityName: String, coord: Coord){
        self.cityName = cityName
        self.coord = coord
    }
    
    init(){
        self.cityName = ""
        self.coord = Coord(lat: 0, lon: 0)
    }
    
}
extension WeatherData: DataSource {
    
    func getDayData(_ dayIndex: Int) -> WeatherDay {
        return data[dayIndex]
    }
    
    func getHourData(_ dayIndex: Int, _ hourIndex: Int) -> WeatherHour {
        return data[dayIndex].forecast[hourIndex]
    }
    
    func getDaysCount() -> Int {
        return data.count
    }
    
    func getCityName() -> String {
        return cityName
    }
    
    func getCoordinates() -> Coord{
        return coord
    }
}

class WeatherDay {
    
    var temp: Int = 0
    var feelsLike: Int = 0
    var icon: String = ""
    var date: Date
    var forecast: [WeatherHour] = []
    
    init(date: Date) {
        self.date = date
    }
    
}
extension WeatherDay: DataSourceDay {
    
    func getDayData() -> WeatherDay {
        return self
    }
    
    func getHourData(_ hourIndex: Int) -> WeatherHour {
        return forecast[hourIndex]
    }
}
