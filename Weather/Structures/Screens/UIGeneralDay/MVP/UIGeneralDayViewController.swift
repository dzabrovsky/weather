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
    
    var presenter: GeneralDayPresenterProtocol!
    
    var contentView: UIGeneralDayView = UIGeneralDayView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setActions()
        presenter.didGeneralDayScreenLoad()
    }
    
    private func setup(){
        
        contentView.onRowSelected() { row in
            self.presenter.showDayDetails(row)
        }
        view = contentView
        contentView.header.delegate = self
    }
    
    private func setActions(){
        contentView.tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
    }
    
    @objc private func pullToRefresh(sender: UIRefreshControl){
        presenter.updateDataByUser()
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

