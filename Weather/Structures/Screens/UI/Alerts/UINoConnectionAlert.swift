import UIKit

class UINoConnectionAlert: UIErrorAlert {
    
    private let contentView: UIErrorAlertView = UIErrorAlertView()
    
    var handler: (() -> ())? {
        didSet{
            guard let handler = handler else { return }
            contentView.setHandler(handler: handler)
        }
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.modalPresentationStyle = .currentContext
        self.modalTransitionStyle = .crossDissolve
        view = contentView
        contentView.setTitle("Что-то пошло не так...")
        contentView.setMessage("Возникли проблемы с интернет соединением. Проверьте своё подключение к интернету.")
    }
}
