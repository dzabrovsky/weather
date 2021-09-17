//
//  UIMapView.swift
//  Weather
//
//  Created by Denis Zabrovsky on 13.09.2021.
//

import UIKit
import MapKit

class UIMapView: UIView {
    
    var presenter: GeneralDayPresenterProtocol
    
    //Actions
    @objc private func onTapBackButton(sender: UIHeaderButton!){
        presenter.onTapBackButton()
    }
    @objc private func onTapGetLocationButton(sender: UIHeaderButton!){
        presenter.onTapLocationButton()
    }
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .standard
        mapView.register(UIAnnotationView.self, forAnnotationViewWithReuseIdentifier: "UIAnnotationView")
        
        return mapView
    }()
    
    let header: UIMapViewHeader = {
        let header = UIMapViewHeader()
        header.backgroundColor = .clear
        header.translatesAutoresizingMaskIntoConstraints = false
        
        return header
    }()
    
    init(presenter: GeneralDayPresenterProtocol) {
        self.presenter = presenter
        super.init(frame: CGRect())
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        
        addSubview(mapView)
        addSubview(header)
        NSLayoutConstraint.activate([
            header.leftAnchor.constraint(equalTo: leftAnchor),
            header.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            header.rightAnchor.constraint(equalTo: rightAnchor),
            header.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 64/375),
            
            mapView.leftAnchor.constraint(equalTo: leftAnchor),
            mapView.rightAnchor.constraint(equalTo: rightAnchor),
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        setActions()
    }
    
    private func setActions(){
        header.locationButton.addTarget(self, action: #selector(onTapGetLocationButton(sender:)), for: .touchDown)
        header.backButton.addTarget(self, action: #selector(onTapBackButton(sender:)), for: .touchDown)
    }
    
    func loadAnnotationsFromDataSource(_ dataSource: WeatherInGeoNamesProtocol) {
        
        let item = dataSource.getItem()
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
        print(pin.coordinate)
        mapView.addAnnotation(pin)
        
    }
    
}
