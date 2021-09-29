import UIKit

public class UITodayWeatherCell: UIWeatherCell {
    
    private static let k: CGFloat = UIScreen.main.bounds.width / 375
    private var dataSource: ForecastDay!
    
    var view:UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var todayLabel:UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "Manrope-Medium", size: 14 * k )
        label.textAlignment = .center
        label.textColor = .white
        
        return label
        
    }()
    
    let weatherImage:UIImageView = {
        
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
        
    }()
    
    let todayTemperatureLabel:UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 48 * k)
        label.textAlignment = .center
        label.textColor = .white
        
        return label
        
    }()
    
    let todayWeatherLabel:UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "Manrope-Medium", size: 14 * k)
        label.textAlignment = .center
        label.textColor = .white
        
        return label
        
    }()
    
    private let gradient = CAGradientLayer()
    private let circleGradient = CAGradientLayer()
    
    private func drawGradient(){
        
        gradient.colors=[ UIColor(red: 68/255, green: 161/255, blue: 1, alpha: 1).cgColor, UIColor(red: 90/255, green: 173/255, blue: 1, alpha: 1).cgColor]
        gradient.startPoint=CGPoint(x: 0.5, y:0)
        gradient.endPoint=CGPoint(x:0.5, y:1)
        gradient.locations=[0,1]
        gradient.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-34, height: (UIScreen.main.bounds.width-34)*0.8)
        gradient.cornerRadius=gradient.bounds.height/12
        
        circleGradient.colors=[ UIColor(red: 64/255, green: 155/255, blue: 1, alpha: 0).cgColor, UIColor(red: 64/255, green: 155/255, blue: 1, alpha: 1).cgColor]
        circleGradient.startPoint=CGPoint(x: 0.5, y: 0.45)
        circleGradient.endPoint=CGPoint(x: 0.5, y: 0)
        circleGradient.locations=[0,1]
        circleGradient.frame=CGRect(x: 0, y: gradient.bounds.height*0.38, width: gradient.bounds.width, height: gradient.bounds.width)
        circleGradient.cornerRadius=gradient.bounds.width/2
        
        view.layer.insertSublayer(circleGradient, at: 0)
        view.layer.insertSublayer(gradient, at: 0)
        
    }
    
    //MARK: - Setup cell methods
    override func setupCell(){
        
        if !isSetuped {
            selectionStyle = .none
            contentView.backgroundColor=#colorLiteral(red: 0.3280947804, green: 0.6626635194, blue: 0.9860203862, alpha: 0)
            backgroundColor=#colorLiteral(red: 0.3280947804, green: 0.6626635194, blue: 0.9860203862, alpha: 0)
            
            layoutView()
            layoutTodayLabel()
            layoutTodayWeatherImage()
            layoutTodayTemperatureLabel()
            layoutTodayWeatherLabel()
            
            isSetuped = true
        }
    }
    
    private func layoutView(){
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: contentView.widthAnchor,multiplier: 0.8).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22).isActive = true
        view.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        
        drawGradient()
    }
    
    private func layoutTodayLabel(){
        view.addSubview(todayLabel)
        todayLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        todayLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.085).isActive = true
        todayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        todayLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
    }
    
    private func layoutTodayWeatherImage(){
        view.addSubview(weatherImage)
        weatherImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35).isActive = true
        weatherImage.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35).isActive = true
        weatherImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        weatherImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 58).isActive = true
    }
    
    private func layoutTodayTemperatureLabel(){
        view.addSubview(todayTemperatureLabel)
        todayTemperatureLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        todayTemperatureLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18).isActive = true
        todayTemperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        todayTemperatureLabel.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 6).isActive=true
    }
    
    private func layoutTodayWeatherLabel(){
        view.addSubview(todayWeatherLabel)
        todayWeatherLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        todayWeatherLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.085).isActive = true
        todayWeatherLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        todayWeatherLabel.topAnchor.constraint(equalTo: todayTemperatureLabel.bottomAnchor, constant: 4).isActive = true
    }
    
    //MARK: - Refresh data with data parameter
    override func refresh(_ dataSource: ForecastDay){
        self.dataSource = dataSource
        todayLabel.text = "Сегодня, " + dataSource.date
        todayTemperatureLabel.text = dataSource.temperature
        todayWeatherLabel.text =  dataSource.description
        
        weatherImage.animationImages = dataSource.icon
        weatherImage.animationDuration = 1.0
        weatherImage.animationRepeatCount = 0
        weatherImage.startAnimating()
    }
    
}
