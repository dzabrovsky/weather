import UIKit

class UIDeleteCellAction: UIContextualAction {
    
    init(completion: @escaping () -> ()) {
        super.init()
        completion()
    }
}
