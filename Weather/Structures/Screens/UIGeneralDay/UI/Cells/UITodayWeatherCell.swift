import UIKit

public class UITodayWeatherCell: UITableViewCell {
    
    var dataSource: ForecastDay!
    
    let dateLabel = UIDateLabel()
    let iconImage = UIIconImage()
    let temperatureLabel = UITemperatureLabel()
    let descriptionLabel = UIDescriptionLabel()
    
    let shapeView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        layuotShape()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        selectionStyle = .none
        contentView.layer.cornerRadius = 24 * screenScale
        backgroundColor = .clear
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func layuotShape() {
        
        shapeView.image = #imageLiteral(resourceName: "generalday_background_day")
        contentView.addSubview(shapeView)
        
        NSLayoutConstraint.activate([
            shapeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shapeView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            shapeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20 * screenScale),
            shapeView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            shapeView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            shapeView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 280/343)
        ])
    }
    
    func layout() {
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubviews([
            dateLabel,
            iconImage,
            descriptionLabel,
            temperatureLabel
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 24/343),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16 * screenScale),
            
            iconImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 120/343),
            iconImage.heightAnchor.constraint(equalTo: iconImage.widthAnchor),
            iconImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImage.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12 * screenScale),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            temperatureLabel.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 52/343),
            temperatureLabel.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 6 * screenScale),
            
            descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 2 * screenScale),
            descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptionLabel.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 24/343),
        ])
    }
    
    func refresh(_ dataSource: ForecastDay){
        self.dataSource = dataSource
        dateLabel.text = "Сегодня, " + dataSource.date
        temperatureLabel.text = dataSource.temperature
        descriptionLabel.text =  dataSource.description
        
        iconImage.animationImages = dataSource.icon
        iconImage.animationDuration = 1.0
        iconImage.animationRepeatCount = 0
        iconImage.startAnimating()
    }
}
