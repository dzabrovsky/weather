import UIKit

protocol TapMarkerGestureDelegate {
    func onTap(_ gesture: TapMarkerGesture)
}

class TapMarkerGesture: UITapGestureRecognizer {
    
    let lat: Double
    let lon: Double
    
    var tapDelegate: TapMarkerGestureDelegate?
    
    init(target: Any?, action: Selector?, lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
        super.init(target: target, action: action)
        addTarget(self, action: #selector(onTapMarker))
    }
    
    @IBAction func onTapMarker(){
        guard state == .ended else { return }
        guard let tapDelegate = tapDelegate else { return }
        tapDelegate.onTap(self)
    }
}
