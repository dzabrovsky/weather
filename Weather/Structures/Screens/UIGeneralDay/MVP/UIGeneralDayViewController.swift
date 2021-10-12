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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
    
    //Methods
    private func setup(){
        
        contentView.tableView.delegate = self
        view = contentView
    }
    
    private func setActions(){
        contentView.header.themeButton.addTarget(self, action: #selector(onTapThemeButton), for: .touchUpInside)
        contentView.header.cityListButton.addTarget(self, action: #selector(onTapCityListButton(sender:)), for: .touchUpInside)
        contentView.header.openMapButton.addTarget(self, action: #selector(onTapGetLocationButton(sender:)), for: .touchUpInside)
        contentView.tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
        
    }
}

extension UIGeneralDayViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showDayDetails(indexPath.row)
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
        self.updateCityName(data.cityName)
    }
    
    func updateCells() {
        
        contentView.tableView.refreshControl?.beginRefreshing()
        contentView.tableView.reloadData()
        contentView.tableView.refreshControl?.endRefreshing()
    }
    
}

