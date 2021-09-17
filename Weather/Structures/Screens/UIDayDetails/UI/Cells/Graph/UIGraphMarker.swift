import UIKit
import Charts

protocol GraphMarkerProtocol: AnyObject {
    func onDraw(sender: UIGraphMarker, point: CGPoint)
}

class UIGraphMarker: MarkerView {
    
    @objc var fillColor: UIColor
    @objc var circleColor: UIColor
    @objc var fillRadius: CGFloat = 6
    @objc var circleRadius: CGFloat = 10.5
    
    weak open var delegate: GraphMarkerProtocol?
    
    @objc public init(circleColor: UIColor ,fillColor: UIColor, frame: CGRect) {
        self.circleColor = circleColor
        self.fillColor = fillColor
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawMarker(context: CGContext, point: CGPoint) {
        
        context.setFillColor(circleColor.cgColor)
        context.fillEllipse(in: CGRect(x: point.x-circleRadius, y: point.y-circleRadius, width: circleRadius*2, height: circleRadius*2))
        context.setFillColor(fillColor.cgColor)
        context.fillEllipse(in: CGRect(x: point.x-fillRadius, y: point.y-fillRadius, width: fillRadius*2, height: fillRadius*2))
    }
    
    override func draw(context: CGContext, point: CGPoint) {
        
        drawMarker(context: context, point: point)
        delegate?.onDraw(sender: self, point: point)
    }
    
}
