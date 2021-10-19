import UIKit

protocol SearchPresenterProtocol: AnyObject {
    
    func onTapBack()
    func onTapThemeButton()
    func onTapAddCity()
    func onTapLocationButton()
    func onAlertTextChanged(_ text: String?)
    
    func inputCityName(_ cityName: String)
    func updateDataSource()
    func onRowSelected(_ index: Int)
    func onDeleteRow(_ index: Int, row: Int, isToLeft: Bool)
    
    func onMoveRow(at source: Int, to destination: Int)
}

class UISearchViewController: UIViewController {
    
    var presenter: SearchPresenterProtocol!
    
    private let cityListAdapter: CityListAdapter = CityListAdapter()
    private var autoCompletionCityNameAdapter: AutoCompletionCityNameAdapter?
    
    var contentView: UISearchView = UISearchView()
    
    override func viewDidLoad(){
        setup()
        setActions()
    }
    
    @objc private func onTapAddCity(sender: UIButton) {
        presenter.onTapAddCity()
    }

    @objc private func onTapLocationButton(sender: UIButton) {
        presenter.onTapLocationButton()
    }
    
    @objc private func onAlertTextChanged(sender: UITextField) {
        presenter.onAlertTextChanged(sender.text)
    }
    
    func setup(){
        view = contentView
        contentView.tableView.dataSource = cityListAdapter
        cityListAdapter.tapDelegate = self
        cityListAdapter.swipeDelegate = self
        cityListAdapter.moveDelegate = self
        contentView.header.delegate = self
        presenter.updateDataSource()
    }
    
    private func setActions(){
        contentView.addCityButton.addTarget(self, action: #selector(onTapAddCity(sender:)), for: .touchUpInside)
        contentView.getLocationButton.addTarget(self, action: #selector(onTapLocationButton(sender:)), for: .touchUpInside)
    }
}
extension UISearchViewController: SearchViewProtocol{
    
    func updateAutoCompletion(_ autoCompletion: SearchResults) {
        guard let autoCompletionCityNameAdapter = autoCompletionCityNameAdapter else { return }
        autoCompletionCityNameAdapter.refreshData(autoCompletion)
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
        
        let inputCity = UIInputCityName(completion: { cityName in
            self.presenter.inputCityName(cityName)
        })
        autoCompletionCityNameAdapter = AutoCompletionCityNameAdapter(textField: inputCity.alert.inputCityName, collectionView: inputCity.alert.citiesCollectionView)
        inputCity.alert.citiesCollectionView.dataSource = autoCompletionCityNameAdapter
        inputCity.alert.citiesCollectionView.delegate = autoCompletionCityNameAdapter
        inputCity.alert.inputCityName.addTarget(self, action: #selector(onAlertTextChanged(sender:)), for: .editingChanged)
        
        self.present(inputCity, animated: true, completion: nil)
    }
    
    func switchTheme() {
        ThemeManager.switchTheme(sender: self)
        contentView.drawGradient()
    }
    func updateCityList(_ data: CityWeather) {
        cityListAdapter.addData(data)
        contentView.tableView.reloadData()
    }
    
    func deleteRowAt(_ index: Int, isToLeft: Bool) {
        cityListAdapter.removeCityAt(index: index)
        contentView.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: isToLeft ? .left:.right)
    }
    
    func reloadCityList() {
        cityListAdapter.removeCityList()
        contentView.tableView.reloadData()
        presenter.updateDataSource()
    }
}

extension UISearchViewController: UIHeaderDelegate {
    func buttonsForHeader() -> [HeaderButton]? {
        var buttons = [HeaderButton]()
        buttons.append(HeaderButton(icon: #imageLiteral(resourceName: "outline_arrow_back_ios_black_48pt"), side: .left){
            self.presenter.onTapBack()
        })
        buttons.append(HeaderButton(icon: #imageLiteral(resourceName: "outline_light_mode_black_48pt"), side: .right){
            self.presenter.onTapThemeButton()
        })
        return buttons
    }
}

extension UISearchViewController: SwipeCellGestureDelegate {
    
    func onSwipe(_ swipeGesture: SwipeCellGesture) {
        presenter.onDeleteRow(swipeGesture.index, row: swipeGesture.row, isToLeft: swipeGesture.direction == .left)
    }
}

extension UISearchViewController: MoveCellGestureDelegate {
    
    func tableViewForLocation() -> UITableView {
        return self.contentView.tableView
    }
    
    func viewForMoveLocation() -> UIView {
        return self.contentView.tableView
    }
    
    func onBegan(_ swipeGesture: MoveCellGesture) {
        guard let snapshot = swipeGesture.snapshot else { return }
        snapshot.center = swipeGesture.cell.center
        self.contentView.tableView.addSubview(snapshot)
        swipeGesture.cell.isHidden = true
    }
    
    func onSwapCells(at source: IndexPath, to destination: IndexPath) {
        presenter.onMoveRow(at: source.row, to: destination.row)
    }
    
    func onEnded(_ swipeGesture: MoveCellGesture) {
    }
}

extension UISearchViewController: TapCellGestureDelegate {
    func onTap(_ tapGesture: TapCellGesture) {
        presenter.onRowSelected(tapGesture.row)
    }
}
