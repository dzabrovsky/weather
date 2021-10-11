import UIKit

protocol SwipeCellGestureDelegate {
    func onSwipe(_ swipeGesture: SwipeCellGesture)
}

class SwipeCellGesture: UISwipeGestureRecognizer {
    
    let index: Int
    let row: Int
    let cell: UIView
    
    var swipeDelegate: SwipeCellGestureDelegate?
    
    init(target: Any?, action: Selector?, index: Int, row: Int, cell: UIView) {
        self.cell = cell
        self.index = index
        self.row = row
        super.init(target: target, action: action)
        direction = .left
        addTarget(self, action: #selector(onSwipeCell))
    }
    
    @IBAction func onSwipeCell(){
        guard state == .ended else { return }
        guard let swipeDelegate = swipeDelegate else { return }
        swipeDelegate.onSwipe(self)
    }
}
