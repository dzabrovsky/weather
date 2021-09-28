import UIKit

class UIWeatherDayCell: UIWeatherCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private static let k: CGFloat = UIScreen.main.bounds.width / 375
    private var dataSource: ForecastDayDataSource!
    
    public let weatherDayItem:UIView = {
        let view = UIView()
        
        view.backgroundColor = #colorLiteral(red: 0.3280947804, green: 0.6626635194, blue: 0.9860203862, alpha: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let header:UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.init(named: "tv_cell_background") ?? .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    public let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10000
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width*0.2, height: UIScreen.main.bounds.width*0.31)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UIHourWeatherCell.self, forCellWithReuseIdentifier: "UIHourWeatherCell")
        return collectionView
    }()
    
    public var dateLabelFirst:UILabel={
        
        let label=UILabel()
        
        label.textColor = UIColor.init(named: "black_text")
        label.text = "01 сентября, "
        label.font = UIFont.init(name: "Manrope-Medium", size: 16 * k)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    public let weatherImage:UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "01d")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let tempLabel:UILabel = {
        let label = UILabel()
        label.text = "25°"
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 16 * k)
        label.textColor = UIColor.init(named: "black_text") ?? .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let tempLabelFeelsLike:UILabel = {
        let label = UILabel()
        label.text = "29°"
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 16 * k)
        label.textColor = UIColor.init(named: "gray_text") ?? .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func layoutCollectionView(){
        
        collectionView.backgroundColor = UIColor.init(named: "tv_cell_background") ?? .black
        collectionView.layer.cornerRadius = bounds.width/20
        collectionView.layer.maskedCorners = [ .layerMinXMaxYCorner, .layerMaxXMaxYCorner ]
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.widthAnchor.constraint(equalTo: weatherDayItem.widthAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: weatherDayItem.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: weatherDayItem.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: weatherDayItem.bottomAnchor).isActive = true
        
        
    }
    
    private func layoutHeader(){
        
        header.widthAnchor.constraint(equalTo: weatherDayItem.widthAnchor).isActive = true
        header.heightAnchor.constraint(equalTo: weatherDayItem.heightAnchor, multiplier: 0.29).isActive = true
        header.leftAnchor.constraint(equalTo: weatherDayItem.leftAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: weatherDayItem.rightAnchor).isActive = true
        header.topAnchor.constraint(equalTo: weatherDayItem.topAnchor).isActive = true
        
        header.addSubview(dateLabelFirst)
        dateLabelFirst.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.5).isActive = true
        dateLabelFirst.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 22).isActive = true
        dateLabelFirst.topAnchor.constraint(equalTo: header.topAnchor, constant: 17).isActive = true
        dateLabelFirst.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -17).isActive = true
        
        header.addSubview(weatherImage)
        weatherImage.widthAnchor.constraint(equalTo: header.heightAnchor, multiplier: 0.5).isActive = true
        weatherImage.heightAnchor.constraint(equalTo: header.heightAnchor, multiplier: 0.5).isActive = true
        weatherImage.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -20).isActive = true
        weatherImage.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        
        header.addSubview(tempLabelFeelsLike)
        tempLabelFeelsLike.rightAnchor.constraint(equalTo: weatherImage.leftAnchor, constant: -16).isActive=true
        tempLabelFeelsLike.topAnchor.constraint(equalTo: header.topAnchor, constant: 17).isActive = true
        tempLabelFeelsLike.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -17).isActive = true
        
        header.addSubview(tempLabel)
        tempLabel.rightAnchor.constraint(equalTo: tempLabelFeelsLike.leftAnchor, constant: -8).isActive = true
        tempLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: 17).isActive = true
        tempLabel.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -17).isActive = true
        
    }
    
    public override func setupCell(){
        
        selectionStyle = .none
        contentView.addSubview(weatherDayItem)
        weatherDayItem.translatesAutoresizingMaskIntoConstraints = false
        weatherDayItem.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        weatherDayItem.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6).isActive = true
        weatherDayItem.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        weatherDayItem.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        weatherDayItem.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        weatherDayItem.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9).isActive = true
        
        backgroundColor = #colorLiteral(red: 0.3280947804, green: 0.6626635194, blue: 0.9860203862, alpha: 0)
        
        weatherDayItem.addSubview(header)
        weatherDayItem.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        layoutHeader()
        
        let underline = UIView()
        header.addSubview(underline)
        underline.backgroundColor = UIColor.init(named: "underline") ?? .black
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.9).isActive = true
        underline.heightAnchor.constraint(equalToConstant: 1).isActive = true
        underline.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        underline.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        
        header.layer.cornerRadius = bounds.width/20
        
        layoutCollectionView()
        
    }
    
    override func refresh(_ dataSource: ForecastDayDataSource) {
        
        self.dataSource = dataSource
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM, E"
        formatter.locale = Locale(identifier: "ru_RU")
        
        let attribute = [ NSAttributedString.Key.font: UIFont.init(name: "Manrope-Medium", size: 16 * UIWeatherDayCell.k)! ]
        let myString = NSMutableAttributedString(string: dataSource.date, attributes: attribute )
        
        myString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.5609950423, green: 0.5900147557, blue: 0.6328315735, alpha: 1) , range: NSRange(location:myString.length-2,length:2))
        dateLabelFirst.attributedText = myString
        
        weatherImage.image = dataSource.icon[0]
        tempLabel.text = dataSource.temperature
        tempLabelFeelsLike.text = dataSource.feelsLike
        
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(row: 4, section: 0), at: [.centeredHorizontally], animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.forecast.count
        }else{
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UIHourWeatherCell",
                                                      for: indexPath) as! UIHourWeatherCell
        
        let view = cell.view
        
        cell.contentView.addSubview(view)
        if let dataSource = dataSource {
            cell.temp.text = dataSource.forecast[indexPath.row].temperature
            cell.time.text = dataSource.forecast[indexPath.row].hour
            cell.weather.image = dataSource.forecast[indexPath.row].icon
        }
        if view.translatesAutoresizingMaskIntoConstraints {
            view.backgroundColor = UIColor.init(named: "cv_cell_background") ?? .black
            view.layer.cornerRadius = collectionView.layer.cornerRadius
            view.heightAnchor.constraint(equalTo: cell.contentView.heightAnchor).isActive = true
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 0).isActive = true
            view.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 0).isActive = true
            view.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 0).isActive = true
            view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 0).isActive = true
            cell.layoutView()
            
        }
        
        return cell
    }
}
