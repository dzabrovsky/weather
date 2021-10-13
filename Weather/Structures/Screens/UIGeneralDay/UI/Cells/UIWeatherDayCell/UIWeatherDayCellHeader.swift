import UIKit

class UIWeatherDayCellHeader: UIView {
    
    var dataSource: UIWeatherDayCellHeaderDataSource?
    
    public var dateLabel: UILabel={
        let label=UILabel()
        label.textColor = UIColor.init(named: "black_text")
        label.font = UIFont.init(name: "Manrope-Medium", size: 16 * screenScale)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    public let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 16 * screenScale)
        label.textColor = UIColor.init(named: "black_text") ?? .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 16 * screenScale)
        label.textColor = UIColor.init(named: "gray_text") ?? .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(){
        super.init(frame: CGRect())
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
    
    private func layout(){
        
        addSubviews([
            dateLabel,
            iconImage,
            feelsLikeLabel,
            temperatureLabel
        ])
        
        NSLayoutConstraint.activate([
            
            dateLabel.widthAnchor.constraint(equalTo: widthAnchor),
            dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20 * screenScale),
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16 * screenScale),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16 * screenScale),
            
            iconImage.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            iconImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            iconImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -20 * screenScale),
            iconImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            feelsLikeLabel.rightAnchor.constraint(equalTo: iconImage.leftAnchor, constant: -16 * screenScale),
            feelsLikeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            temperatureLabel.rightAnchor.constraint(equalTo: feelsLikeLabel.leftAnchor, constant: -8 * screenScale),
            temperatureLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func reloadData(){
        dataSource?.reloadData(self)
    }
}
