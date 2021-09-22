import UIKit

protocol GeneralDayPresenterProtocol: AnyObject {
    
    func didGeneralDayScreenLoad()
    
    func updateDataByUser()
    func onTapThemeButton()
    func onTapCityListButton()
    func onTapLocationButton()
    func showDayDetails(_ dataSource: ForecastDayDataSource)
    
}

class UIGeneralDayViewController: UIViewController {
    
    var presenter: GeneralDayPresenterProtocol!
    
    var contentView: UIGeneralDayView = UIGeneralDayView()
    
    private var dataSource: ForecastDataSource?
    
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
        contentView.tableView.dataSource = self
        
        view = contentView
        ThemeManager.setLastTheme(sender: self)
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
        if let dataSource = dataSource {
            //presenter.showDayDetails(dataSource.getDayData(indexPath.row))
        }
    }
    
}

extension UIGeneralDayViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.forecast.count - 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row > 0{
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UIWeatherDayCell", for: indexPath) as? UIWeatherDayCell else {
                assertionFailure()
                return UITableViewCell()
            }
            cell.setupCell()
            if let dataSource = dataSource {
                cell.refresh(dataSource.forecast[indexPath.row])
            }
            return cell
            
        }else{
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITodayWeatherCell", for: indexPath) as? UITodayWeatherCell else {
                assertionFailure()
                return UITableViewCell()
            }
            cell.setupCell()
            if let dataSource = dataSource {
                cell.refresh(dataSource.forecast[indexPath.row])
            }
            return cell
            
        }
    }
}

extension UIGeneralDayViewController: GeneralDayViewProtocol {
    
    func switchTheme() {
        
        ThemeManager.switchTheme(sender: self)
    }
    
    func updateCityName(_ name: String) {
        self.contentView.header.title.text = name
    }
    
    func refreshData(_ dataSource: ForecastDataSource){
        
        self.dataSource = dataSource
        self.contentView.tableView.reloadData()
        self.contentView.tableView.refreshControl?.endRefreshing()
        self.updateCityName(dataSource.cityName)
    }
    
    func updateCells() {
        
        contentView.tableView.refreshControl?.beginRefreshing()
        contentView.tableView.reloadData()
        contentView.tableView.refreshControl?.endRefreshing()
    }
    
}

