import UIKit

class GeneralDayDelegateAdapter: NSObject {
    
    private var delegate: ((Int) -> ())?
    
    func setDelegate(delegate: @escaping (Int) -> ()) {
        self.delegate = delegate
    }
}

extension GeneralDayDelegateAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else { return }
        delegate(indexPath.row)
    }
}
