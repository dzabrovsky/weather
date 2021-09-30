import UIKit
import Charts

protocol UIChartMarkerProtocol {
    func hideSelf()
    func showSelf()
    func setValues(temperature: String, feelsLike: String, icon: UIImage)
}

class UIChart: UITableViewCell {
    
    static let k: CGFloat = UIScreen.main.bounds.width / 375

    var dataSource: ForecastDay!
    
    let chart: LineChartView = {
        let chart = LineChartView()
        
        chart.backgroundColor = .clear
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        chart.leftAxis.drawLabelsEnabled = false
        chart.leftAxis.drawZeroLineEnabled = false
        chart.leftAxis.drawAxisLineEnabled = false
        chart.leftAxis.gridLineDashLengths = [5 * k]
        chart.leftAxis.gridColor = UIColor.init(named: "underline") ?? .black
        chart.rightAxis.enabled = false
        
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.labelWidth = 43 * k
        chart.xAxis.labelTextColor = UIColor.init(named: "gray_text") ?? .black
        chart.xAxis.drawAxisLineEnabled = false
        chart.xAxis.drawGridLinesEnabled = false
        
        chart.legend.enabled = false
        chart.zoom(scaleX: 1.33, scaleY: 1, x: 0, y: 0)
        chart.scaleXEnabled = false
        chart.scaleYEnabled = false
        chart.xAxis.labelFont = UIFont.init(name: "Lato-Regular", size: 14 * k) ?? UIFont.systemFont(ofSize: 12)
        chart.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        chart.setDragOffsetX(0)
        
        return chart
    }()
    
    let gradient: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: -0.1, y:0.5)
        layer.endPoint = CGPoint(x:0.33, y:0.5)
        layer.locations = [0,1]
        
        layer.colors=[
            (UIColor.init(named: "daydetails_gradient_bottom") ?? .clear).cgColor,
            (UIColor.init(named: "daydetails_gradient_top") ?? .clear).cgColor
        ]
        
        return layer
    }()
    
    let marker = UIChartMarker(circleColor: #colorLiteral(red: 0.2744562328, green: 0.631960392, blue: 0.9857184291, alpha: 1), fillColor: UIColor.init(named: "tv_cell_background") ?? .clear)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layoutSelf()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutSelf(){
        backgroundColor = .clear
        contentView.backgroundColor = UIColor.init(named: "tv_cell_background")
        contentView.layer.cornerRadius = 24 * UIChart.k
        
        chart.delegate = self
        chart.layer.addSublayer(gradient)
    }
    
    func setup(){
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        contentView.addSubview(chart)
        NSLayoutConstraint.activate([
            chart.topAnchor.constraint(equalTo: contentView.topAnchor),
            chart.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            chart.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            chart.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -36 * UIChart.k),
            chart.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 206/326),
        ])
        
    }
    
    func setupChart(_ data: [ChartDataEntry]) {
        
        let chartDataSet = LineChartDataSet(entries: data)
        chartDataSet.mode = .horizontalBezier
        chartDataSet.lineWidth = 4
        chartDataSet.colors = [#colorLiteral(red: 0.2744562328, green: 0.631960392, blue: 0.9857184291, alpha: 1)]
        chartDataSet.drawVerticalHighlightIndicatorEnabled = false
        chartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        chartDataSet.drawCirclesEnabled = false
        
        let chartData = LineChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        marker.setup()
        chart.marker = marker
        chart.data = chartData
    }
    
    func loadChart(_ dataSource: ForecastDay){
        chart.xAxis.valueFormatter = CustomValueFormatter()
        var chartData: [ChartDataEntry] = []
        self.dataSource = dataSource
        
        chartData.append(ChartDataEntry(x: -1, y: dataSource.forecast[0].tempValue))
        var i = 0
        for hour in dataSource.forecast {
            chartData.append(ChartDataEntry(x: Double(i), y: hour.tempValue))
            i += 1
        }
        chartData.append(
            ChartDataEntry(
                x: Double(dataSource.forecast.count),
                y: dataSource.forecast[dataSource.forecast.count-1].tempValue
            )
        )
        
        let max: Double = dataSource.forecast.max(by: { a, b in a.tempValue < b.tempValue })?.tempValue ?? 1
        let min: Double = dataSource.forecast.min(by: { a, b in a.tempValue < b.tempValue })?.tempValue ?? 0
        
        chart.leftAxis.axisMaximum = max * 2
        chart.leftAxis.axisMinimum = min / 2
        setupChart(chartData)
        setupGradient()
    }
    
    func setupGradient(){
        gradient.cornerRadius = 24 * UIChart.k
        gradient.frame = CGRect(x: 0, y: 0, width: 326 * UIChart.k, height: 242 * UIChart.k)
        gradient.cornerRadius = gradient.bounds.height/12
    }
    
    func switchTheme(){
        gradient.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        gradient.colors=[
            (UIColor.init(named: "daydetails_gradient_bottom") ?? .clear).cgColor,
            (UIColor.init(named: "daydetails_gradient_top") ?? .clear).cgColor
        ]
        marker.imageView.tintColor = UIColor.init(named: "hour_weather_marker")
    }
    
}

extension UIChart: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let marker = chartView.marker as? UIChartMarkerProtocol else { return }
        guard entry.x >= 0 && entry.x <= 7 else{
            marker.hideSelf()
            return
        }
        marker.showSelf()
        let index = Int(entry.x)
        marker.setValues(
            temperature: dataSource.forecast[index].temperature,
            feelsLike: dataSource.forecast[index].feelsLike,
            icon: dataSource.forecast[index].icon
        )
    }
}
