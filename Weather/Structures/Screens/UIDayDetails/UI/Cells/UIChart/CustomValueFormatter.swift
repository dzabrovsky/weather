import Foundation
import Charts

class CustomValueFormatter: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        print(value)
        
        let value = Int(value)
        guard value > -1 && value < 8 else { return "" }
        
        return String(value*3) + ":00"
    }
}
