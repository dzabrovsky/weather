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
    
    func snapshotFromCell() -> UIView? {
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0)
        if let CurrentContext = UIGraphicsGetCurrentContext() {
            cell.layer.render(in: CurrentContext)
        }
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        UIGraphicsEndImageContext()
        let snapshot = UIImageView(image: image)
        return snapshot
    }
    
    @IBAction func onSwipeCell(){
        guard state == .ended else { return }
        guard let swipeDelegate = swipeDelegate else { return }
        swipeDelegate.onSwipe(self)
    }
    
    private func onBegan() {
        snapshot = snapshotFromCell()
        guard let viewForLocation = viewForLocation else { return }
        let location = location(in: viewForLocation)
        startLocation = location.x
    }
    
    private func onChanged() {
        guard let viewForLocation = viewForLocation else { return }
        let location = location(in: viewForLocation)
        distance =  location.x - startLocation
        direction = distance < 0 ? .left : .right
        isSwiped = abs(distance*1.1) > swipeDisctance
        moveSnapshotBySwipe()
    }
    
    private func onEnded() {
        guard !isSwiped else { return }
        guard let snapshot = snapshot else { return }
        animateCellBack(snapshot, cell: self.cell)
    }
    
    private func moveSnapshotBySwipe() {
        guard let snapshot = self.snapshot else { return }
        var center = snapshot.center
        center.x = UIScreen.main.bounds.width/2 + distance*1.1
        snapshot.center = center
    }
    
    private func animateCellBack(_ snapshot: UIView, cell: UIView) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations: {
                snapshot.center = cell.center
            },
            completion: { _ in
                cell.isHidden = false
                snapshot.removeFromSuperview()
                snapshot.isHidden = true
            }
        )
    }
}
