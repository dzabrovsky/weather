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

fileprivate var snapshot: UIView?
fileprivate var startLocation: CGFloat = 0

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
    
    private func customSnapshotFromView(inputView: UIView) -> UIView? {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        if let CurrentContext = UIGraphicsGetCurrentContext() {
            inputView.layer.render(in: CurrentContext)
        }
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        UIGraphicsEndImageContext()
        let snapshot = UIImageView(image: image)
        return snapshot
    }
    
    @objc func enableEditingTableView() {
        self.contentView.tableView.isEditing = true
    }
    
    @IBAction func onSwipeCell(_ gestureRecognizer: UIGestureRecognizer){
        guard let recognizer = gestureRecognizer as? SwipeCellGesture else { return }
        let location = recognizer.location(in: self.contentView.tableView)
        switch recognizer.state {
        case .began:
            snapshot = self.customSnapshotFromView(inputView: recognizer.cell)
            guard  let snapshot = snapshot else { return }
            let center = recognizer.cell.center
            snapshot.center = recognizer.cell.center
            snapshot.center = center
            self.contentView.tableView.addSubview(snapshot)
            recognizer.cell.isHidden = true
            startLocation = location.x
        case .changed:
            guard let snapshot = snapshot else { return }
            var center = snapshot.center
            center.x = UIScreen.main.bounds.width/2 + location.x - startLocation
            snapshot.center = center
        case .ended:
            guard let snapshot = snapshot else { return }
            let distance = location.x - startLocation
            if abs(distance) > UIScreen.main.bounds.width/4 {
                snapshot.removeFromSuperview()
                recognizer.cell.center = snapshot.center
                recognizer.cell.isHidden = false
                
                presenter.onDeleteRow(recognizer.index, row: recognizer.row, isToLeft: distance < 0)
            } else {
                UIView.animate(
                    withDuration: 0.3,
                    delay: 0,
                    usingSpringWithDamping: 0.3,
                    initialSpringVelocity: 1,
                    options: .curveEaseInOut,
                    animations: {
                        snapshot.center = recognizer.cell.center
                    },
                    completion: { _ in
                        recognizer.cell.isHidden = false
                        snapshot.removeFromSuperview()
                    }
                )
            }
        default:
            print("another")
        }
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
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
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
            action: #selector(onSwipeCell(_:)),
            index: dataSource[indexPath.row].index,
            row: indexPath.row,
            cell: cell
        )
        
        cell.addGestureRecognizer(swipeGesture)
        cell.cityName.text = city.name
        cell.temp.text = city.temp
        cell.tempFeelsLike.text = city.feelsLike
        cell.icon.image = city.icon
        
        return cell
    }
    
}
