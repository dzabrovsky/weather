import UIKit

protocol UIWeatherDayCellHeaderDataSource {
    func reloadData(_ header: UIWeatherDayCellHeader)
}

fileprivate let k: CGFloat = UIScreen.main.bounds.width / 375

class GeneralDayForecastDayAdapter: NSObject {
    private var data: ForecastDay?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM, E"
        formatter.locale = Locale(identifier: "ru_RU")
        
        return formatter
    }()
    
    func setData(_ data: ForecastDay) {
        self.data = data
    }
    
    private func formatDate(_ date: String) -> NSAttributedString {
        let attribute = [ NSAttributedString.Key.font: UIFont.init(name: "Manrope-Medium", size: 16 * k)! ]
        let myString = NSMutableAttributedString(string: date, attributes: attribute )
        
        myString.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: #colorLiteral(red: 0.5609950423, green: 0.5900147557, blue: 0.6328315735, alpha: 1) ,
            range: NSRange(location:myString.length-2,length:2)
        )
        return myString
    }
}

extension GeneralDayForecastDayAdapter: UIWeatherDayCellHeaderDataSource {
    func reloadData(_ header: UIWeatherDayCellHeader) {
        guard let data = data else { return }
        header.dateLabel.attributedText = formatDate(data.date)
        header.temperatureLabel.text = data.temperature
        header.feelsLikeLabel.text = data.feelsLike
        header.iconImage.image = data.icon[0]
    }
}

extension GeneralDayForecastDayAdapter: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = data else { return 0 }
        return data.forecast.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = data else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UIHourWeatherCell", for: indexPath) as! UIHourWeatherCell
        cell.refreshData(data.forecast[indexPath.row])
        return cell
    }
}
