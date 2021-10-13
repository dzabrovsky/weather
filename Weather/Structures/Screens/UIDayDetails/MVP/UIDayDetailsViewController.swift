import UIKit

protocol DayDetailsPresenterProtocol {
    func onTapBackButton()
    func onTapThemeButton()
    func onTapCityListButton()
    func onViewDidLoad()
}

class UIDayDetailsViewController: UIViewController{

    var presenter: DayDetailsPresenterProtocol!
    var dataSource: ForecastDay!
    var cityName: String!
    
    let contentView = UIDayDetailsView()
    
    @objc private func onTapThemeButton(sender: UIHeaderButton!){
        presenter.onTapThemeButton()
    }
    
    @objc private func onTapCityListButton(sender: UIHeaderButton!){
        presenter.onTapCityListButton()
    }
    
    @objc private func onTapBackButton(sender: UIHeaderButton!){
        presenter.onTapBackButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = contentView
        contentView.header.delegate = self
        contentView.tableView.dataSource = self
        presenter.onViewDidLoad()
    }
    
}
extension UIDayDetailsViewController: UIDayDetailsViewControllerProtocol{
    func updateView() {
        contentView.header.title.text = cityName
        contentView.tableView.reloadData()
    }
    
    func switchtheme() {
        ThemeManager.switchTheme(sender: self)
        contentView.tableView.reloadData()
    }
}

extension UIDayDetailsViewController: UIHeaderDelegate {
    func buttonsForHeader() -> [HeaderButton]? {
        var buttons = [HeaderButton]()
        buttons.append(HeaderButton(icon: #imageLiteral(resourceName: "outline_arrow_back_ios_black_48pt"), side: .left){
            self.presenter.onTapBackButton()
        })
        buttons.append(HeaderButton(icon: #imageLiteral(resourceName: "outline_search_black_48pt"), side: .right){
            self.presenter.onTapCityListButton()
        })
        buttons.append(HeaderButton(icon: #imageLiteral(resourceName: "outline_light_mode_black_48pt"), side: .right){
            self.presenter.onTapThemeButton()
        })
        return buttons
    }
}

extension UIDayDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UIDetails", for: indexPath) as? UIDetails else {
                assertionFailure()
                return UITableViewCell()
            }
            
            cell.setup()
            
            if let dataSource = dataSource {
                cell.refresh(dataSource)
            }
            return cell
            
        }else{
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UIChart", for: indexPath) as? UIChart else {
                assertionFailure()
                return UITableViewCell()
            }
            
            if let dataSource = dataSource {
                cell.loadChart(dataSource)
                cell.switchTheme()
            }
            return cell
            
        }
    }
}
