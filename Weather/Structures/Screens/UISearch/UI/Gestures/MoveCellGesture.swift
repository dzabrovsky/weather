import UIKit

protocol MoveCellGestureDelegate {
    func viewForMoveLocation() -> UIView
    func tableViewForLocation() -> UITableView
    func onBegan(_ swipeGesture: MoveCellGesture)
    func onSwapCells(at source: IndexPath, to destination: IndexPath)
    func onEnded(_ swipeGesture: MoveCellGesture)
}

class MoveCellGesture: UILongPressGestureRecognizer {
    
    let index: Int
    let row: Int
    let cell: UITableViewCell
    
    var snapshot: UIView?
    
    var sourceLocation: CGPoint = CGPoint(x: 0, y: 0)
    var destinateLocation: CGPoint = CGPoint(x: 0, y: 0)
    
    private var viewForLocation: UIView?
    private var tableView: UITableView?
    
    private var startLocation: CGPoint = CGPoint(x: 0, y: 0)
    
    var moveDelegate: MoveCellGestureDelegate? {
        didSet{
            self.tableView = self.moveDelegate?.tableViewForLocation()
            self.viewForLocation = self.moveDelegate?.viewForMoveLocation()
        }
    }
    
    init(target: Any?, action: Selector?, index: Int, row: Int, cell: UITableViewCell) {
        self.cell = cell
        self.index = index
        self.row = row
        super.init(target: target, action: action)
        addTarget(self, action: #selector(onPressCell))
    }
    
    func snapshotFromCell() -> UIView? {
        UIGraphicsBeginImageContextWithOptions(cell.contentView.bounds.size, false, 0)
        if let CurrentContext = UIGraphicsGetCurrentContext() {
            cell.contentView.layer.render(in: CurrentContext)
        }
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        UIGraphicsEndImageContext()
        let snapshot = UIImageView(image: image)
        return snapshot
    }
    
    @IBAction func onPressCell(){
        guard let moveDelegate = moveDelegate else { return }
        switch self.state {
        case .began:
            self.onBegan()
            moveDelegate.onBegan(self)
        case .changed:
            self.onChanged()
        case .ended:
            self.onBack()
            moveDelegate.onEnded(self)
            startLocation = CGPoint(x: 0, y: 0)
        default:
            print("Another state")
        }
    }
    
    private func onBegan() {
        snapshot = snapshotFromCell()
        guard let viewForLocation = viewForLocation else { return }
        startLocation = location(in: viewForLocation)
        sourceLocation = startLocation
    }
    
    private func onChanged() {
        guard let moveDelegate = moveDelegate else { return }
        let location = location(in: viewForLocation)
        destinateLocation = location
        guard let sourcePath = tableView?.indexPathForRow(at: sourceLocation) else { return }
        guard let destinatePath = tableView?.indexPathForRow(at: destinateLocation) else { return }
        if sourcePath != destinatePath {
            guard let tableView = tableView else { return }
            tableView.moveRow(at: destinatePath, to: sourcePath)
            moveDelegate.onSwapCells(at: sourcePath, to: destinatePath)
            sourceLocation = location
        }
        moveSnapshotBySwipe()
    }
    
    private func onBack() {
        guard let snapshot = snapshot else { return }
        animateCellBack(snapshot, cell: cell)
    }
    
    private func moveSnapshotBySwipe() {
        guard let snapshot = self.snapshot else { return }
        guard let tableView = self.tableView else { return }
        
        let location = location(in: viewForLocation)
        var center = snapshot.center
        
        guard let indexPath = tableView.indexPathForRow(at: CGPoint(x: location.x, y: location.y - snapshot.bounds.height/2)) else { return }
        guard let firstIndexPath = tableView.indexPathsForVisibleRows?.first else { return }
        guard let lastIndexPath = tableView.indexPathsForVisibleRows?.last else { return }
        
        if indexPath.row == firstIndexPath.row && indexPath.row > 0{
            tableView.scrollToRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section), at: .top, animated: true)
        }
        
        if indexPath.row == lastIndexPath.row && indexPath.row < tableView.numberOfRows(inSection: indexPath.section) - 1 {
            tableView.scrollToRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section), at: .bottom, animated: true)
        }
        center.y = location.y
        
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
