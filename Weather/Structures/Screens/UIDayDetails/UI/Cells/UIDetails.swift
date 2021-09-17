//
//  UIDetails.swift
//  Weather
//
//  Created by Denis Zabrovsky on 06.09.2021.
//

import UIKit

class UIDetails: UITableViewCell {
    
    private weak var dataSource: DataSourceDay!
    
    var dateLabel:UILabel = {
        
        let label = UILabel()
        label.text = "Сегодня, 12 августа, чт"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "Manrope-Medium", size: 16)
        label.textAlignment = .center
        label.textColor = .white
        
        return label
        
    }()
    
    let weatherImage:UIImageView = {
        
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "01d")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
        
    }()
    
    let temperatureLabel:UILabel = {
        
        let label = UILabel()
        label.text = "30°C"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 52)
        label.textAlignment = .center
        label.textColor = .white
        
        return label
        
    }()
    
    let weatherLabel:UILabel = {
        
        let label = UILabel()
        label.text = "Ясно, ощущается как 32°"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "Manrope-Medium", size: 16)
        label.textAlignment = .center
        label.textColor = .white
        
        return label
        
    }()
    
    let info: UIDetailsInfo = {
        let view = UIDetailsInfo()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private let gradient = CAGradientLayer()
    let circleGradientImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = #imageLiteral(resourceName: "circle_gradient")
        image.alpha = 0.9
        return image
    }()
    
    private func drawGradient(){
        
        gradient.colors=[ UIColor(red: 68/255, green: 161/255, blue: 1, alpha: 1).cgColor, UIColor(red: 90/255, green: 173/255, blue: 1, alpha: 1).cgColor]
        gradient.startPoint=CGPoint(x: 0.5, y:0)
        gradient.endPoint=CGPoint(x:0.5, y:1)
        gradient.locations=[0,1]
        gradient.frame = self.bounds
        gradient.cornerRadius=gradient.bounds.height/12
        
    }
    
    func setup(){
        
        self.backgroundColor=#colorLiteral(red: 0.3280947804, green: 0.6626635194, blue: 0.9860203862, alpha: 0)
        
        layoutView()
    }
    
    private func layoutView(){
        
        contentView.addSubview(circleGradientImage)
        contentView.addSubview(dateLabel)
        contentView.addSubview(weatherImage)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherLabel)
        contentView.addSubview(info)
        drawGradient()
        contentView.layer.insertSublayer(gradient, at: 0)
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            dateLabel.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 24/343),
            
            weatherImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherImage.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12),
            weatherImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 120/343),
            weatherImage.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 120/343),
            
            circleGradientImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            circleGradientImage.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            circleGradientImage.topAnchor.constraint(equalTo: weatherImage.centerYAnchor),
            circleGradientImage.heightAnchor.constraint(equalTo: circleGradientImage.widthAnchor, multiplier: 174/343),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 6),
            temperatureLabel.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 52/343),
            
            weatherLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 2),
            weatherLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            weatherLabel.heightAnchor.constraint(equalTo: weatherLabel.widthAnchor, multiplier: 24/343),
            
            info.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            info.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 32),
            info.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 66/386),
            info.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            info.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
        ])
    }
    
    func refresh(_ dataSource: DataSourceDay){
        self.dataSource = dataSource
        dateLabel.text = {
            var text = "Сегодня, "
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM, E"
            formatter.locale = Locale(identifier: "ru_RU")
            
            text += formatter.string(from: dataSource.getDayData().date).lowercased()
            
            return text
        }()
        temperatureLabel.text = String(Int(dataSource.getHourData(0).main.temp)) + "°"
        weatherLabel.text = dataSource.getHourData(0).weather[0].weatherDescription + ", ощущается как " + String(Int(dataSource.getHourData(0).main.feelsLike))+"°"
        
        weatherImage.image = ImageManager.getIconByCode(dataSource.getHourData(0).weather[0].icon)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        drawGradient()
    }
}
