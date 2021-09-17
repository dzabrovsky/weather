//
//  UIDetailsInfo.swift
//  Weather
//
//  Created by Denis Zabrovsky on 06.09.2021.
//

import UIKit

class UIDetailsInfo: UIView {
    
    private static let k: CGFloat = UIScreen.main.bounds.width / 375
    
    private let windText: UILabel = {
        let label = UILabel()
        label.text = "Ветер"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.init(name: "Manrope-Medium", size: 14 * k)
        label.textAlignment = .center
        
        return label
    }()
    
    private let humidityText: UILabel = {
        let label = UILabel()
        label.text = "Влажность"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.init(name: "Manrope-Medium", size: 14 * k)
        label.textAlignment = .center
        
        return label
    }()
    
    private let precipitationText: UILabel = {
        let label = UILabel()
        label.text = "Осадки"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.init(name: "Manrope-Medium", size: 14 * k)
        label.textAlignment = .center
        
        return label
    }()
    private var windLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center

        return label
    }()
    
    private var humidityLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private var precipitationLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getAttributedString(text: String, count: Int) -> NSMutableAttributedString {
        
        let attribute = [NSAttributedString.Key.font: UIFont.init(name: "Manrope-ExtraBold", size: 32 * UIDetailsInfo.k)! ]
        let attributedString = NSMutableAttributedString(string: text, attributes: attribute )
        
        attributedString.addAttribute(
            NSAttributedString.Key.font,
            value: UIFont.init(name: "Manrope-ExtraBold", size: 16 * UIDetailsInfo.k) ?? UIFont.boldSystemFont(ofSize: 16 * UIDetailsInfo.k),
            range: NSRange(location: attributedString.length-count, length: count))
        return attributedString
    }
    
    func setInfo(wind: String, humidity: String, precipitation: String) {
        
        windLabel.attributedText = getAttributedString(text: wind, count: 3)
        humidityLabel.attributedText = getAttributedString(text: humidity, count: 1)
        precipitationLabel.attributedText = getAttributedString(text: precipitation, count: 1)
        
    }
    
    private func setup() {
        
        self.addSubview(windText)
        self.addSubview(humidityText)
        self.addSubview(precipitationText)

        NSLayoutConstraint.activate([
            windText.leftAnchor.constraint(equalTo: leftAnchor),
            windText.topAnchor.constraint(equalTo: topAnchor),
            windText.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3),
            windText.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 24/66),
            
            humidityText.centerXAnchor.constraint(equalTo: centerXAnchor),
            humidityText.topAnchor.constraint(equalTo: topAnchor),
            humidityText.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3),
            humidityText.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 24/66),
            
            precipitationText.rightAnchor.constraint(equalTo: rightAnchor),
            precipitationText.topAnchor.constraint(equalTo: topAnchor),
            precipitationText.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3),
            precipitationText.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 24/66)
            
        ])
        
        self.addSubview(windLabel)
        self.addSubview(humidityLabel)
        self.addSubview(precipitationLabel)
        
        NSLayoutConstraint.activate([
            windLabel.leftAnchor.constraint(equalTo: leftAnchor),
            windLabel.topAnchor.constraint(equalTo: windText.bottomAnchor, constant: 2),
            windLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            windLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3),
            
            humidityLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            humidityLabel.topAnchor.constraint(equalTo: humidityText.bottomAnchor, constant: 2),
            humidityLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            humidityLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3),
            
            precipitationLabel.rightAnchor.constraint(equalTo: rightAnchor),
            precipitationLabel.topAnchor.constraint(equalTo: precipitationText.bottomAnchor, constant: 2),
            precipitationLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            precipitationLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3)
                
        ])
        setInfo(wind: "5м/с", humidity: "28%", precipitation: "95%")
        
    }
    
}
