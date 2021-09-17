//
//  UICityListTableViewCell.swift
//  Weather
//
//  Created by Denis Zabrovsky on 03.09.2021.
//

import UIKit

class UICityListTableViewCell: UITableViewCell {
    
    private static let k: CGFloat = UIScreen.main.bounds.width / 375
    let cityName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(named: "black_text")
        label.font = UIFont.init(name: "Manrope-Medium", size: 16 * k)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let temp: UILabel = {
        let label = UILabel()
        label.text = "26°"
        label.textColor = UIColor.init(named: "black_text")
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 16 * k)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let tempFeelsLike: UILabel = {
        let label = UILabel()
        label.text = "25°"
        label.textColor = UIColor.init(named: "gray_text")
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 16 * k)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "11d")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let view = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        
        self.backgroundColor = UIColor.init(named: "background")
        contentView.backgroundColor = UIColor.init(named: "background")
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        view.backgroundColor = UIColor.init(named: "tv_cell_background")
        
        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 60/343),
        ])
        
        view.addSubview(cityName)
        view.addSubview(temp)
        view.addSubview(tempFeelsLike)
        view.addSubview(icon)
        
        NSLayoutConstraint.activate([
            cityName.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            icon.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            tempFeelsLike.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            temp.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
        ])
        
        UIView.animate(withDuration: 0.2){
            self.layoutIfNeeded()
        }
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            cityName.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 197/343),
            cityName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            cityName.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            icon.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            icon.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            icon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            temp.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            temp.rightAnchor.constraint(equalTo: tempFeelsLike.leftAnchor, constant: -8),
            temp.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tempFeelsLike.rightAnchor.constraint(equalTo: icon.leftAnchor, constant: -16),
            tempFeelsLike.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tempFeelsLike.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
            
        ])
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool){
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
}
