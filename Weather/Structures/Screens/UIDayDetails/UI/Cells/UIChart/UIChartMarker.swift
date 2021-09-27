import UIKit
import Charts

class UIChartMarker: MarkerView {
    
    private static let k: CGFloat = UIScreen.main.bounds.width / 375
    
    @objc var fillColor: UIColor
    @objc var circleColor: UIColor
    @objc var fillRadius: CGFloat = 6
    @objc var circleRadius: CGFloat = 10.5
    
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.init(named: "hour_weather_marker")
        imageView.image = #imageLiteral(resourceName: "annotation_icon")
        imageView.frame = CGRect(x: -38 * k, y: -94 * k, width: 76 * k, height: 81 * k)
        
        return imageView
    }()
    
    let weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "Sun_120x120_00017")
        imageView.frame = CGRect(x: 0, y: 6 * k, width: 76 * k, height: 32 * k)
        
        return imageView
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 16 * k)
        label.textColor = UIColor.init(named: "black_text")
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 37 * k, width: 38 * k, height: 37 * k)
        
        return label
    }()
    
    let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Manrope-ExtraBold", size: 16 * k)
        label.textColor = UIColor.init(named: "gray_text")
        label.textAlignment = .center
        label.frame = CGRect(x: 38 * k, y: 37 * k, width: 38 * k, height: 37 * k)
        
        return label
    }()
    
    @objc public init(circleColor: UIColor ,fillColor: UIColor) {
        self.circleColor = circleColor
        self.fillColor = fillColor
        
        super.init(frame: CGRect())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        addSubview(imageView)
        imageView.addSubview(weatherIcon)
        imageView.addSubview(tempLabel)
        imageView.addSubview(feelsLikeLabel)
    }
    
    private func drawMarker(context: CGContext, point: CGPoint) {
        
        context.setFillColor(circleColor.cgColor)
        context.fillEllipse(in: CGRect(x: point.x-circleRadius, y: point.y-circleRadius, width: circleRadius*2, height: circleRadius*2))
        context.setFillColor(fillColor.cgColor)
        context.fillEllipse(in: CGRect(x: point.x-fillRadius, y: point.y-fillRadius, width: fillRadius*2, height: fillRadius*2))
    }
    
    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)
        drawMarker(context: context, point: point)
    }
}
