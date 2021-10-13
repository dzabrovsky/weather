//
//  HourWeatherViewCellCollectionViewCell.swift
//  Weather
//
//  Created by Denis Zabrovsky on 19.08.2021.
//

import UIKit

fileprivate let k: CGFloat = UIScreen.main.bounds.width / 375

public class UIHourWeatherCell: UICollectionViewCell {
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Manrope-Medium", size: 16 * k)
        label.textAlignment = .center
        label.textColor = UIColor.init(named: "gray_text")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 16 * k)
        label.textAlignment = .center
        label.textColor = UIColor.init(named: "black_text")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let shapeView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        
        contentView.backgroundColor = UIColor.init(named: "cv_cell_background")
        contentView.layer.cornerRadius = 16 * k
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        contentView.addSubviews([
            shapeView,
            temperatureLabel,
            timeLabel,
            iconImage
        ])
        
        NSLayoutConstraint.activate([
            shapeView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            shapeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shapeView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            shapeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            shapeView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 73/375),
            shapeView.heightAnchor.constraint(equalTo: shapeView.widthAnchor, multiplier: 114/73),
            
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12 * k),
            
            iconImage.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 32/73),
            iconImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 32/73),
            iconImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12 * k)
        ])
    }
    
    func refreshData(_ data: ForecastHour) {
        temperatureLabel.text = data.temperature
        iconImage.image = data.icon
        timeLabel.text = data.hour
    }
}
