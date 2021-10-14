import UIKit

fileprivate let k: CGFloat = UIScreen.main.bounds.width / 375

class UIDetails: UITodayWeatherCell {
    
    let info: UIDetailsInfo = {
        let view = UIDetailsInfo()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()

    override func layuotShape() {
        shapeView.image = #imageLiteral(resourceName: "daydetails_background_day")
        
        contentView.addSubview(shapeView)
        NSLayoutConstraint.activate([
            shapeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shapeView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            shapeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20 * k),
            shapeView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            shapeView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            shapeView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 386/343)
        ])
    }
    
    override func layout(){
        
        super.layout()
        
        contentView.addSubview(info)
        
        NSLayoutConstraint.activate([
            info.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 66/386),
            info.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            info.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            info.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32 * k),
        ])
    }
    
    override func refresh(_ dataSource: ForecastDay){
        super.refresh(dataSource)
        info.setInfo(wind: dataSource.wind, humidity: dataSource.humidity, precipitation: dataSource.precipitation)
    }
}
