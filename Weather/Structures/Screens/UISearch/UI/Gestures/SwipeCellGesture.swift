import UIKit

class SwipeCellGesture: UIPanGestureRecognizer {
    
    let index: Int
    let row: Int
    let cell: UIView
    
    init(target: Any?, action: Selector?, index: Int, row: Int, cell: UIView) {
        self.cell = cell
        self.index = index
        self.row = row
        super.init(target: target, action: action)
    }
    
}
