import UIKit

protocol WeatherPresenterProtocol: AnyObject {
    
    func didDataUpdated()
    func changeLocation()
    func setCityByUser(_ cityName:String)
    func getCurrentCityName() -> String
    func updateDataByUser()
    
}

class ViewController: UIViewController {
    
    private var presenterObject: WeatherPresenter!
    private var presenter: WeatherPresenterProtocol!
    private let contentView: UIGeneralDayView = {
        let view = UIGeneralDayView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private unowned var dataSource: DataSource!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        presenterObject = WeatherPresenter(self)
        self.presenter = presenterObject
        
        view.window?.overrideUserInterfaceStyle = .light
        
        setupUI()

        //presenter.updateDataByUser()
        
    }
    
    let refreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    @objc private func pullToRefresh(sender: UIRefreshControl){
        
        presenter.updateDataByUser()
        
    }
    
    private func setupUI(){
        
        view.addSubview(contentView)
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        
    }
    
}

extension ViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row > 0{
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UIWeatherDayCell", for: indexPath) as? UIWeatherDayCell else {
                assertionFailure()
                return UITableViewCell()
            }
            cell.setupCell()
            if let dataSource = dataSource {
                cell.refresh(dataSource.getDayData(indexPath.row))
            }
            return cell
            
        }else{
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITodayWeatherCell", for: indexPath) as? UITodayWeatherCell else {
                assertionFailure()
                return UITableViewCell()
            }
            cell.setupCell()
            if let dataSource = dataSource {
                cell.refresh(dataSource.getDayData(indexPath.row))
            }
            return cell
            
        }
        
    }
    
}

extension ViewController: WeatherViewProtocol{
    
    func updateCityName(_ name: String) {
        self.contentView.header.title.text = name
    }
    
    
    func updateCity(_ city: String) {
        
    }
    
    func refreshData(_ dataSource: DataSource){
        self.dataSource = dataSource
        self.contentView.tableView.reloadData()
        self.contentView.tableView.refreshControl?.endRefreshing()
    }
    
    func updateCells() {
        contentView.tableView.refreshControl?.beginRefreshing()
        contentView.tableView.reloadData()
        contentView.tableView.refreshControl?.endRefreshing()
    }
    
}

