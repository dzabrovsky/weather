//
//  UIAnnotationView.swift
//  Weather
//
//  Created by Denis Zabrovsky on 14.09.2021.
//

import UIKit
import MapKit

class UIAnnotationView: MKAnnotationView {
    
    private static let k: CGFloat = UIScreen.main.bounds.width / 375
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.init(named: "hour_weather_marker")
        imageView.image = #imageLiteral(resourceName: "annotation_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 16 * k)
        label.textColor = UIColor.init(named: "black_text")
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 16 * k)
        label.textColor = UIColor.init(named: "gray_text")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setup()
        animate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        
        image = #imageLiteral(resourceName: "annotation_alpha0")
        
        addSubview(imageView)
        addSubview(weatherIcon)
        addSubview(tempLabel)
        addSubview(feelsLikeLabel)
        
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func animate(){
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            
            weatherIcon.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 34/76),
            weatherIcon.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 34/76),
            weatherIcon.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 7 * UIAnnotationView.k),
            weatherIcon.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            
            tempLabel.rightAnchor.constraint(equalTo: imageView.centerXAnchor, constant: -3 * UIAnnotationView.k),
            tempLabel.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 6.5 * UIAnnotationView.k),
            
            feelsLikeLabel.leftAnchor.constraint(equalTo: imageView.centerXAnchor, constant: 3 * UIAnnotationView.k),
            feelsLikeLabel.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 6.5 * UIAnnotationView.k),
            
        ])
        
        UIView.animate(withDuration: 0.3){
            self.imageView.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.5){
            self.weatherIcon.layoutIfNeeded()
            self.tempLabel.layoutIfNeeded()
            self.feelsLikeLabel.layoutIfNeeded()
        }
    }
    
    public func setValues(icon: UIImage, temperature: String, feelsLike: String){
        
        weatherIcon.image = icon
        tempLabel.text = temperature
        feelsLikeLabel.text = feelsLike
        
    }
}
