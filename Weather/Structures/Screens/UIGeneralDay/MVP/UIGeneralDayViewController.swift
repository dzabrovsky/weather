import UIKit

protocol GeneralDayPresenterProtocol: AnyObject {
    
    func didGeneralDayScreenLoad()
    
    func updateDataByUser()
    func onTapThemeButton()
    func onTapCityListButton()
    func onTapLocationButton()
    func showDayDetails(_ index: Int)
}

class UIGeneralDayViewController: UIViewController {
    
    let presenter: GeneralDayPresenterProtocol
    
    private let contentView: UIGeneralDayView = UIGeneralDayView()
    
    init(_ presenter: GeneralDayPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setActions()
        presenter.didGeneralDayScreenLoad()
    }
    
    private func setup(){
        view = contentView
        contentView.header.delegate = self
    }
    
    private func setActions(){
        contentView.onRowSelected() { row in
            self.presenter.showDayDetails(row)
        }
        contentView.tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
    }
    
    @objc private func pullToRefresh(sender: UIRefreshControl){
        self.presenter.updateDataByUser()
    }
}

extension UIGeneralDayViewController: UIHeaderDelegate {
    func buttonsForHeader() -> [HeaderButton]? {
        var buttons = [HeaderButton]()
        buttons.append(HeaderButton(icon: #imageLiteral(resourceName: "outline_search_black_48pt"), side: .right){
            self.presenter.onTapCityListButton()
        })
        buttons.append(HeaderButton(icon: #imageLiteral(resourceName: "outline_place_black_48pt"), side: .left){
            self.presenter.onTapLocationButton()
        })
        buttons.append(HeaderButton(icon: #imageLiteral(resourceName: "outline_light_mode_black_48pt"), side: .right){
            self.presenter.onTapThemeButton()
        })
        return buttons
    }
}

extension UIGeneralDayViewController: GeneralDayViewProtocol {
    
    func switchTheme() {
        ThemeManager.switchTheme(sender: self)
    }
    
    func updateCityName(_ name: String) {
        self.contentView.header.title.text = name
    }
    
    func refreshData(_ data: Forecast){
        self.contentView.refreshData(data)
    }
}

