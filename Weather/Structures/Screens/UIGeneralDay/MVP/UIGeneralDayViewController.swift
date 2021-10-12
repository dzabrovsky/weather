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
    }
    
    private func setActions(){
        contentView.header.openMapButton.addTarget(self, action: #selector(onTapGetLocationButton(sender:)), for: .touchUpInside)
        contentView.header.themeButton.addTarget(self, action: #selector(onTapThemeButton), for: .touchUpInside)
        contentView.header.cityListButton.addTarget(self, action: #selector(onTapCityListButton(sender:)), for: .touchUpInside)
        contentView.tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
    }
    
    //Actions
    @objc private func onTapGetLocationButton(sender: UIHeaderButton!){
        presenter.onTapLocationButton()
    }
    
    @objc private func onTapThemeButton(sender: UIHeaderButton!){
        presenter.onTapThemeButton()
    }
    
    @objc private func onTapCityListButton(sender: UIHeaderButton!){
        presenter.onTapCityListButton()
    }
    
    @objc private func pullToRefresh(sender: UIRefreshControl){
        presenter.updateDataByUser()
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
    
    func updateCells() {
        
        contentView.tableView.refreshControl?.beginRefreshing()
        contentView.tableView.reloadData()
        contentView.tableView.refreshControl?.endRefreshing()
    }
    
}

