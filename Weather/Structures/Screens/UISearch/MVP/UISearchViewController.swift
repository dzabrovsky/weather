import UIKit

protocol SearchPresenterProtocol: AnyObject {
    
    func onTapBack()
    func onTapThemeButton()
    func onTapAddCity()
    func inputCityName(_ cityName: String)
    func updateDataSource()
    func onRowSelected(_ cityName: String)
}

class UISearchViewController: UIViewController {
    
    var dataSource: [CityDataSource] = []
    
    var presenter: SearchPresenterProtocol!
    
    var contentView: UISearchView = UISearchView()
    
    override func viewDidLoad(){
        view = contentView
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        
        setup()
        setActions()
    }
    
    @objc private func onTapThemeButton(sender: UIHeaderButton!){
        presenter.onTapThemeButton()
    }
    
    @objc private func onTapAddCity(sender: UIHeaderButton!){
        presenter.onTapAddCity()
    }
    @objc private func onTapBack(sender: UIHeaderButton!){
        presenter.onTapBack()
    }
    
    func setup(){
        presenter.updateDataSource()
    }
    
    private func setActions(){
        contentView.header.themeButton.addTarget(self, action: #selector(onTapThemeButton(sender:)), for: .touchDown)
        contentView.header.backButton.addTarget(self, action: #selector(onTapBack(sender:)), for: .touchDown)
        contentView.addCityButton.addTarget(self, action: #selector(onTapAddCity(sender:)), for: .touchDown)
    }
    
}
extension UISearchViewController: SearchViewProtocol{
    
    func showAlertCityDoesNotExists() {
        let alert = UIAlertController(title: "Что-то пошло не так...", message: "Город с таким названием не найден!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil ))
        self.present(alert, animated: true, completion: nil )
    }
    
    func showAlertCityAlreadyExists() {
        let alert = UIAlertController(title: "Что-то пошло не так...", message: "Вы уже добавили этот город в список городов!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil ))
        self.present(alert, animated: true, completion: nil )
    }
    
    func openAddCityAlert() {
        
        let inputCity = UIInputCityName(completion: { cityName in
            DispatchQueue.main.async {
                self.presenter.inputCityName(cityName)
            }
        })
        inputCity.modalPresentationStyle = .overCurrentContext
        inputCity.modalTransitionStyle = .crossDissolve
        
        self.present(inputCity, animated: true, completion: nil)
    }
    
    func switchTheme() {
        
        ThemeManager.switchTheme(sender: self)
        
        if #available(iOS 13, *) {
            
            guard let view = view as? UISearchView else{ return }
            view.drawGradient()
        }
    }
    func updateCityList(_ dataSource: CityDataSource) {
        self.dataSource.append(dataSource)
        contentView.tableView.reloadData()
    }
    
}
extension UISearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.onRowSelected( dataSource[indexPath.row].name)
    }
}

extension UISearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UICityListTableViewCell", for: indexPath) as! UICityListTableViewCell
        
        let city = dataSource[indexPath.row]
        
        cell.cityName.text = city.name
        cell.temp.text = city.temp
        cell.tempFeelsLike.text = city.feelsLike
        cell.icon.image = city.icon
        
        return cell
    }
    
}
