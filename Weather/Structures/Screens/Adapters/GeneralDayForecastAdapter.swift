import UIKit

class GeneralDayForecastAdapter: NSObject {
    private var data: Forecast?
    
    func setData(_ data: Forecast) {
        self.data = data
    }
}

extension GeneralDayForecastAdapter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = data else { return 5 }
        return data.forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UIWeatherDayCell", for: indexPath) as? UIWeatherDayCell
            else { return UITableViewCell() }
            if let data = data {
                cell.refresh(data.forecast[indexPath.row])
            }
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITodayWeatherCell", for: indexPath) as? UITodayWeatherCell
            else { return UITableViewCell() }
            if let data = data {
                cell.refresh(data.forecast[indexPath.row])
            }
            return cell
        }
    }
}
