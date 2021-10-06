import UIKit

protocol SearchPresenterProtocol: AnyObject {
    
    func onTapBack()
    func onTapThemeButton()
    func onTapAddCity()
    func onTapLocationButton()
    func onAlertTextChanged(_ text: String?)
    
    func inputCityName(_ cityName: String)
    func updateDataSource()
    func onRowSelected(_ cityName: String)
    func onDeleteRow(_ index: Int, row: Int, isToLeft: Bool)
    
    func onMoveRow(at: Int, to: Int)
}

class UISearchViewController: UIViewController {
    
    var dataSource: [CityWeather] = []
    
    var presenter: SearchPresenterProtocol!
    
    var contentView: UISearchView = UISearchView()
    var inputCity: UIInputCityName!
    
    override func viewDidLoad(){
        view = contentView
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        
        setup()
        setActions()
    }
    
    @objc private func onTapThemeButton(sender: UIHeaderButton!) {
        presenter.onTapThemeButton()
    }
    
    @objc private func onTapAddCity(sender: UIButton) {
        presenter.onTapAddCity()
    }
    
    @objc private func onTapBack(sender: UIHeaderButton!) {
        presenter.onTapBack()
    }
    
    @objc private func onTapLocationButton(sender: UIButton) {
        presenter.onTapLocationButton()
    }
    
    @objc private func onAlertTextChanged(sender: UITextField) {
        presenter.onAlertTextChanged(sender.text)
    }
    
    func setup(){
        presenter.updateDataSource()
    }
    
    private func setActions(){
        contentView.header.themeButton.addTarget(self, action: #selector(onTapThemeButton(sender:)), for: .touchUpInside)
        contentView.header.backButton.addTarget(self, action: #selector(onTapBack(sender:)), for: .touchUpInside)
        contentView.addCityButton.addTarget(self, action: #selector(onTapAddCity(sender:)), for: .touchUpInside)
        contentView.getLocationButton.addTarget(self, action: #selector(onTapLocationButton(sender:)), for: .touchUpInside)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(enableEditingTableView))
        longPressGesture.minimumPressDuration = 1
        self.contentView.tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func enableEditingTableView() {
        self.contentView.tableView.isEditing = true
    }
}
extension UISearchViewController: SearchViewProtocol{
    
    func updateAutoCompletion(_ autoCompletion: SearchResults) {
        inputCity.refreshAutoCompletion(autoCompletion)
    }
    
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
        
        inputCity = UIInputCityName(completion: { cityName in
            self.presenter.inputCityName(cityName)
        })
        inputCity.alert.inputCityName.addTarget(self, action: #selector(onAlertTextChanged(sender:)), for: .editingChanged)
        inputCity.modalPresentationStyle = .overCurrentContext
        inputCity.modalTransitionStyle = .crossDissolve
        
        self.present(inputCity, animated: true, completion: nil)
    }
    
    func switchTheme() {
        ThemeManager.switchTheme(sender: self)
        contentView.drawGradient()
    }
    func updateCityList(_ dataSource: CityWeather) {
        self.dataSource.append(dataSource)
        contentView.tableView.reloadData()
    }
    
    func deleteRowAt(_ index: Int, isToLeft: Bool) {
        dataSource.remove(at: index)
        contentView.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: isToLeft ? .left:.right)
    }
    
    func reloadCityList() {
        dataSource.removeAll()
        presenter.updateDataSource()
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
        
        let swipeGesture = SwipeCellGesture(
            target: self,
            action: nil,
            index: dataSource[indexPath.row].index,
            row: indexPath.row,
            cell: cell
        )
        swipeGesture.swipeDelegate = self
        
        cell.addGestureRecognizer(swipeGesture)
        cell.cityName.text = city.name
        cell.temp.text = city.temp
        cell.tempFeelsLike.text = city.feelsLike
        cell.icon.image = city.icon
        
        return cell
    }
    
}

extension UISearchViewController: SwipeCellGestureDelegate {
    
    func viewForLocation() -> UIView {
        return contentView.tableView
    }
    
    func onBegan(_ swipeGesture: SwipeCellGesture) {
        guard let snapshot = swipeGesture.snapshot else { return }
        snapshot.center = swipeGesture.cell.center
        self.contentView.tableView.addSubview(snapshot)
        swipeGesture.cell.isHidden = true
    }
    
    func onChanged(_ swipeGesture: SwipeCellGesture) {
        
    }
    
    func onEnded(_ swipeGesture: SwipeCellGesture) {
        guard let snapshot = swipeGesture.snapshot else { return }
        if swipeGesture.isSwiped {
            snapshot.removeFromSuperview()
            swipeGesture.cell.center = snapshot.center
            swipeGesture.cell.isHidden = false
            snapshot.isHidden = true
            presenter.onDeleteRow(swipeGesture.index, row: swipeGesture.row, isToLeft: swipeGesture.direction == .left)
        }
    }
}
