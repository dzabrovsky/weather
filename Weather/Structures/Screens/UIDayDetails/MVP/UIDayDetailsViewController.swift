import UIKit

protocol DayDetailsPresenterProtocol {
    func onTapBackButton()
    func onTapThemeButton()
    func onTapCityListButton()
    func onViewDidLoad()
}

class UIDayDetailsViewController: UIViewController{

    var presenter: DayDetailsPresenterProtocol!
    var dataSource: ForecastDayDataSource!
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
    
    private func setActions(){
        contentView.header.themeButton.addTarget(self, action: #selector(onTapThemeButton(sender:)), for: .touchUpInside)
        contentView.header.backButton.addTarget(self, action: #selector(onTapBackButton(sender:)), for: .touchUpInside)
        contentView.header.cityListButton.addTarget(self, action: #selector(onTapCityListButton(sender:)), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = contentView
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        setActions()
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
    }
}

extension UIDayDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension UIDayDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x:0,y:0,width: 1, height: 20))
    }
    
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
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UIGraph", for: indexPath) as? UIGraph else {
                assertionFailure()
                return UITableViewCell()
            }
            
            if let dataSource = dataSource {
                cell.refresh(dataSource)
            }
            return cell
            
        }
    }
}
