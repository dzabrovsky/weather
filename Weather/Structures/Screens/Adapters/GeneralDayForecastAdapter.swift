import UIKit

class GeneralDayForecastAdapter: NSObject {
    let data: Forecast
    
    init(data: Forecast) {
        self.data = data
    }
}

extension GeneralDayForecastAdapter: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row > 0{
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UIWeatherDayCell", for: indexPath) as? UIWeatherDayCell else {
                assertionFailure()
                return UITableViewCell()
            }
            cell.setupCell()
            cell.refresh(data.forecast[indexPath.row])
            return cell
            
        }else{
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITodayWeatherCell", for: indexPath) as? UITodayWeatherCell else {
                assertionFailure()
                return UITableViewCell()
            }
            cell.setupCell()
            cell.refresh(data.forecast[indexPath.row])
            return cell
            
        }
    }
}
