import UIKit

protocol TapCellGestureDelegate {
    func onTap(_ tapGesture: TapCellGesture)
}

class TapCellGesture: UITapGestureRecognizer {
    let row: Int
    
    var tapDelegate: TapCellGestureDelegate?
    
    init(target: Any?, action: Selector?, row: Int) {
        self.row = row
        super.init(target: target, action: action)
        addTarget(self, action: #selector(onSwipeCell))
    }
    
    @IBAction func onSwipeCell(){
        guard state == .ended else { return }
        guard let tapDelegate = tapDelegate else { return }
        tapDelegate.onTap(self)
    }
}
