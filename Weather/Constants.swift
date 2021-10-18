import UIKit

let langConstant: String = "ru"
let unitsConstant: String = "metric"
let APIKeyConstant: String = "830e252225a6214c4370ecfee9b1d912"
let APIUserNameConstant: String = "ivan"

let defaultCityName = "Moscow"
let defaultCoordinates = Coordindates(lat: 55.751244, lon: 37.618423)

let screenScale: CGFloat = UIScreen.main.bounds.width / 375

let forecastURL = "https://api.openweathermap.org/data/2.5/forecast"
let timemachineURL = "http://api.openweathermap.org/data/2.5/onecall/timemachine"
let citiesJSONURL = "http://api.geonames.org/citiesJSON"
let currentWeatherURL = "https://api.openweathermap.org/data/2.5/weather"
let searchJSONURL = "http://api.geonames.org/searchJSON?"
