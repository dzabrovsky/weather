//
//  HourWeatherViewCellCollectionViewCell.swift
//  Weather
//
//  Created by Denis Zabrovsky on 19.08.2021.
//

import UIKit

public class UIHourWeatherCell: UICollectionViewCell {
    
    private static let k: CGFloat = UIScreen.main.bounds.width / 375
    
    public var id:Int = 0
    
    public let time:UILabel = {
        let label = UILabel()
        label.text = "01:00"
        label.font = UIFont.init(name: "Manrope-Medium", size: 16 * k)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.5609950423, green: 0.5900147557, blue: 0.6328315735, alpha: 1)
        
        return label
    }()
    
    public let weather:UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "01d")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    public let temp:UILabel = {
        let label = UILabel()
        label.text = "25°"
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 16 * k)
        label.textAlignment = .center
        label.textColor = UIColor.init(named: "black_text")
        
        return label
    }()
    
    public let view:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(named: "cv_cell_background")
        
        return view
    }()
    
    public override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func layoutView(){
        
        view.addSubview(time)
        view.addSubview(weather)
        view.addSubview(temp)
        
        time.translatesAutoresizingMaskIntoConstraints = false
        time.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.21).isActive = true
        time.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        time.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        time.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        
        weather.translatesAutoresizingMaskIntoConstraints = false
        weather.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.44).isActive = true
        weather.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.44).isActive = true
        weather.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        weather.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 6).isActive = true
        
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.21).isActive = true
        temp.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        temp.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: weather.bottomAnchor, constant: 5).isActive = true
        
    }
}
