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
    
    let header: UIHeader = {
        let header = UIHeader()
        header.backgroundColor = .clear
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
    
    func addAnnotationFromData(_ data: Geoname) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: data.lat, longitude: data.lon)
        print(annotation.coordinate)
        map.addAnnotation(annotation)
        
    }
    
}
