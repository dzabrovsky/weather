import UIKit
import MapKit

class UIMapView: UIView {
    
    let map: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.mapType = .standard
        map.register(UIAnnotationView.self, forAnnotationViewWithReuseIdentifier: "UIAnnotationView")
        
        return map
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
        
        map.showsCompass = false
        map.showsScale = false
        map.mapType = .standard

    }
    
    private func layout() {
        addSubview(map)
        addSubview(header)
        NSLayoutConstraint.activate([
            header.leftAnchor.constraint(equalTo: leftAnchor),
            header.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            header.rightAnchor.constraint(equalTo: rightAnchor),
            header.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 64/375),
            
            map.leftAnchor.constraint(equalTo: leftAnchor),
            map.rightAnchor.constraint(equalTo: rightAnchor),
            map.topAnchor.constraint(equalTo: topAnchor),
            map.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func loadAnnotationFromData(_ data: GeonameDataSource) {
        
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: data.lat, longitude: data.lon)
        print(pin.coordinate)
        map.addAnnotation(pin)
        
    }
    
}
