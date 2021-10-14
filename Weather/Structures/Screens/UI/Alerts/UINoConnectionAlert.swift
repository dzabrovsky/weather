import UIKit

class UINoConnectionAlert: UIErrorAlert {
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        title = "Что-то пошло не так..."
        message = "Возникли проблемы с интернет соединением. Проверьте своё подключение к интернету."
        addAction(UIAlertAction(title: "Ок", style: .cancel, handler: nil))
    }
}
