//
//  UISearchView.swift
//  Weather
//
//  Created by Denis Zabrovsky on 03.09.2021.
//

import UIKit

class UISearchView: UIView {
    
    private static let k: CGFloat = UIScreen.main.bounds.width / 375
    
    let header: UIHeader = {
        let header = UIHeader()
        header.title.text = "Мои города"
        return header
    }()
    
    let tableView: UICityListTableView = {
        let tableView = UICityListTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y:1)
        gradient.endPoint = CGPoint(x:0.5, y:0)
        gradient.locations = [0,1]
        gradient.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height: UIScreen.main.bounds.height*193/647)
        
        return gradient
    }()
    
    let gradientView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let addCityButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.init(named: "apply_button_background")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Manrope-Medium", size: 14 * k)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 12
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    let getLocationButton: UIHeaderButton = {
        let button = UIHeaderButton(6, side: .right)
        button.icon.image = #imageLiteral(resourceName: "outline_place_black_48pt")
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    init() {
        super.init(frame: CGRect())
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawGradient(){
        let colors: [CGColor] = [UIColor.init(named: "search_gradient_bottom")?.cgColor ?? UIColor.white.cgColor, UIColor.init(named: "search_gradient_top")?.cgColor ?? UIColor.clear.cgColor]
        gradient.colors = colors
    }
    
    func setupUI(){
        
        drawGradient()
        gradientView.layer.insertSublayer(gradient, at: 0)
        
        self.backgroundColor = UIColor.init(named: "background")
        self.addSubview(header)
        self.addSubview(tableView)
        self.addSubview(gradientView)
        
        
        NSLayoutConstraint.activate([
            gradientView.widthAnchor.constraint(equalTo: widthAnchor),
            gradientView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 193/647),
            gradientView.leftAnchor.constraint(equalTo: leftAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            header.leftAnchor.constraint(equalTo: leftAnchor),
            header.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            header.rightAnchor.constraint(equalTo: rightAnchor),
            header.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 64/375)
        ])
        
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: -4),
            tableView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            tableView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16)
        ])
        
        let viewContainer: UIView = UIView()
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(viewContainer)
        NSLayoutConstraint.activate([
            viewContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 200/375),
            viewContainer.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 40/375),
            viewContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            viewContainer.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        viewContainer.addSubview(addCityButton)
        NSLayoutConstraint.activate([
            addCityButton.widthAnchor.constraint(equalTo: viewContainer.widthAnchor, multiplier: 152/200),
            addCityButton.heightAnchor.constraint(equalTo: viewContainer.heightAnchor),
            addCityButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor)
        ])
        
        viewContainer.addSubview(getLocationButton)
        NSLayoutConstraint.activate([
            getLocationButton.rightAnchor.constraint(equalTo: viewContainer.rightAnchor),
            getLocationButton.heightAnchor.constraint(equalTo: viewContainer.heightAnchor),
            getLocationButton.widthAnchor.constraint(equalTo: viewContainer.heightAnchor)
        ])
        
    }
    
}
