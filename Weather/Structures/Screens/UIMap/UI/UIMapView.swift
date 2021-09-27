//
//  UIMapView.swift
//  Weather
//
//  Created by Denis Zabrovsky on 13.09.2021.
//

import UIKit
import MapKit

class UIMapView: UIView {
    
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
    
    init() {
        super.init(frame: CGRect())
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.mapType = .standard

    }
    
    private func layout() {
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
    }
    
    func loadAnnotationFromDataSource(_ dataSource: GeonameDataSource) {
        
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2D(latitude: dataSource.lat, longitude: dataSource.lon)
            print(pin.coordinate)
            mapView.addAnnotation(pin)
        
    }
    
}
