import UIKit

extension UIViewController {
    
    func showAlertNoConnection() {
        let alert = UINoConnectionAlert()
        alert.handler = {
            alert.dismiss(animated: true, completion: nil)
        }
        present(alert, animated: true)
    }
    
    func showAlertError() {
        let alert = UIAnyErrorAlert()
        alert.handler = {
            alert.dismiss(animated: true, completion: nil)
        }
        present(alert, animated: true)
    }
}
