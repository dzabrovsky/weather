import UIKit
import MapKit

protocol GeneralDayPresenterProtocol: AnyObject {
    
    func updateDataByUser()
    func onTapOpenMapButton()
    func onTapThemeButton()
    func onTapCityListButton()
    func onTapLocationButton()
    func onTapBackButton()
    func onApplyNewCityName(_ cityName:String)
    func onTapAnnotation(lat: Double, lon: Double)
    func mapViewDidFinishLoadingMap(centerLon: Double, centerLat: Double, lonA: Double, latA: Double)
    func showDayDetails(_ dataSource: DataSourceDay)
    
}

class UIGeneralDayViewController: UICustomViewController {
    
    var presenter: GeneralDayPresenterProtocol!
    
    var contentView: UIGeneralDayView = UIGeneralDayView()
    var contentMapView: UIMapView = {
        let mapView = UIMapView()
        mapView.mapView.showsCompass = false
        mapView.mapView.showsScale = false
        
        return mapView
    }()
    
    private var dataSource: DataSource?
    private var geonamesDataSource: WeatherInGeoNamesProtocol?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        setActions()
        presenter.updateDataByUser()
    }
    
    //Actions
    @objc private func onTapBackButton(sender: UIHeaderButton!){
        presenter.onTapBackButton()
    }
    
    @objc private func onTapGetLocationButton(sender: UIHeaderButton!){
        presenter.onTapLocationButton()
    }
    
    @objc private func onTapOpenMapButton(sender: UIHeaderButton!){
        presenter.onTapOpenMapButton()
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
    private func setupUI(){
        
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        
        contentMapView.mapView.delegate = self
        
        view = contentView
        ThemeManager.setLastTheme(sender: self)
    }
    
    private func setActions(){
        contentMapView.header.locationButton.addTarget(self, action: #selector(onTapGetLocationButton(sender:)), for: .touchUpInside)
        contentMapView.header.backButton.addTarget(self, action: #selector(onTapBackButton(sender:)), for: .touchUpInside)
        
        contentView.header.themeButton.addTarget(self, action: #selector(onTapThemeButton), for: .touchUpInside)
        contentView.header.openMapButton.addTarget(self, action: #selector(onTapOpenMapButton(sender:)), for: .touchUpInside )
        contentView.header.cityListButton.addTarget(self, action: #selector(onTapCityListButton(sender:)), for: .touchUpInside)
        contentView.tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
        
    }
    
}

extension UIGeneralDayViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dataSource = dataSource {
            presenter.showDayDetails(dataSource.getDayData(indexPath.row))
        }
    }
    
}

extension UIGeneralDayViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.getDaysCount() - 1
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

extension UIGeneralDayViewController: GeneralDayViewProtocol {
    
    func switchTheme() {
        
        ThemeManager.switchTheme(sender: self)
    }
    
    func updateCityName(_ name: String) {
        self.contentView.header.title.text = name
    }
    
    func refreshData(_ dataSource: DataSource){
        
        self.dataSource = dataSource
        self.contentView.tableView.reloadData()
        self.contentView.tableView.refreshControl?.endRefreshing()
        self.updateCityName(dataSource.getCityName())
    }
    
    func updateCells() {
        
        contentView.tableView.refreshControl?.beginRefreshing()
        contentView.tableView.reloadData()
        contentView.tableView.refreshControl?.endRefreshing()
    }
    
    func openMap() {
        
        if let dataSource = dataSource {
            contentMapView.header.title.text = dataSource.getCityName()
            
            contentMapView.mapView.setRegion(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: dataSource.getCoordinates().lat,
                        longitude: dataSource.getCoordinates().lon
                    ),
                    latitudinalMeters: CLLocationDistance.init(100000),
                    longitudinalMeters: CLLocationDistance.init(100000)
                ),
                animated: true
            )
            
            contentMapView.mapView.mapType = .standard
            view = contentMapView
        }
    }
    func closeMap() {
        
        contentMapView = UIMapView()
        view = contentView
    }
    
    func refreshCitiesOnMap(_ dataSource: WeatherInGeoNamesProtocol) {
        
        contentMapView.loadAnnotationsFromDataSource(dataSource)
        geonamesDataSource = dataSource
    }
    
    func updateLocationOnMap(lat: Double, lon: Double) {
        contentMapView.mapView.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: lon), animated: true)
    }
    
}

extension UIGeneralDayViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            presenter.onTapAnnotation(lat: annotation.coordinate.latitude, lon: annotation.coordinate.longitude)
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        
        presenter.mapViewDidFinishLoadingMap(centerLon: mapView.region.center.longitude, centerLat: mapView.region.center.latitude, lonA: mapView.region.span.longitudeDelta, latA: mapView.region.span.latitudeDelta)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "UIAnnotationView") as! UIAnnotationView
        
        if let geonamesDataSource = geonamesDataSource {
            if let data = geonamesDataSource.getItemByLocation(lat: annotation.coordinate.latitude, lon: annotation.coordinate.longitude){
                
                annotationView.setValues(icon: ImageManager.getIconByCode(data.icon), temp: Int(data.temp), feelsLike: Int(data.tempFeelsLike))
            }
        }
        return annotationView
    }
    
}
