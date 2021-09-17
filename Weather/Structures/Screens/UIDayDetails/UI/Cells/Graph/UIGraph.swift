//
//  UIGraph.swift
//  Weather
//
//  Created by Denis Zabrovsky on 06.09.2021.
//

import UIKit
import Charts

class UIGraph: UITableViewCell {
    
    let chartView: LineChartView = {
        let chart = LineChartView()
        chart.backgroundColor = .clear
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        chart.rightAxis.enabled = false
        chart.xAxis.enabled = false
        chart.leftAxis.enabled = false
        chart.legend.enabled = false
        chart.setExtraOffsets(left: 15, top: 0, right: 15, bottom: 0)
        chart.setExtraOffsets(left: 10, top: 0, right: 10, bottom: 10)
        
        return chart
    }()
    
    let leftGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        
        //gradient.colors=[ #colorLiteral(red: 0.9612689614, green: 0.9737938046, blue: 0.9491464496, alpha: 1).cgColor, UIColor(red: 245/255, green: 248/255, blue: 242/255, alpha: 0).cgColor ]
        
        return gradient
    }()
    
    var graphItems: [UIGraphItem] = []
    var graphItemsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumInteritemSpacing = 1000
        flowLayout.itemSize = CGSize(width: 43, height: 218)
        
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(UIGraphItem.self, forCellWithReuseIdentifier: "UIGraphItem" )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    var dataSource: DataSourceDay?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        chartView.data = chartData
        
        chartView.marker = UIGraphMarker(circleColor: #colorLiteral(red: 0.2744562328, green: 0.631960392, blue: 0.9857184291, alpha: 1), fillColor: UIColor.init(named: "tv_cell_background")!, frame: CGRect())
    }
    
    func setup() {
        
        graphItemsCollectionView.delegate = self
        graphItemsCollectionView.dataSource = self
        
        self.backgroundColor = UIColor.init(named: "tv_cell_background")
        self.layer.cornerRadius = 26
        contentView.addSubview(chartView)
        chartView.addSubview(graphItemsCollectionView)
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            contentView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            chartView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            chartView.topAnchor.constraint(equalTo: contentView.topAnchor),
            chartView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            chartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            chartView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 242 / 343),
            
            graphItemsCollectionView.leftAnchor.constraint(equalTo: chartView.leftAnchor),
            graphItemsCollectionView.widthAnchor.constraint(equalTo: chartView.widthAnchor),
            graphItemsCollectionView.bottomAnchor.constraint(equalTo: chartView.bottomAnchor),
            graphItemsCollectionView.heightAnchor.constraint(equalTo: chartView.heightAnchor)
        ])
        
        chartView.zoom(scaleX: 1.33, scaleY: 1, x: 0, y: 0)
        chartView.doubleTapToZoomEnabled = false
        chartView.layer.insertSublayer(leftGradient, at: 0)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        leftGradient.startPoint = CGPoint(x: -0.1, y:0.5)
        leftGradient.endPoint = CGPoint(x:0.33, y:0.5)
        leftGradient.locations = [0,1]
        leftGradient.frame = self.bounds
        leftGradient.cornerRadius = leftGradient.bounds.height/12
        
    }
    
    private func addGraphItem(leftAnchor: NSLayoutXAxisAnchor, widthMultiplier: CGFloat, _ hidden: Bool = false) -> NSLayoutXAxisAnchor {
        
        let graphItem = UIGraphItem()
        graphItem.isHidden = hidden
        graphItem.translatesAutoresizingMaskIntoConstraints = false
        chartView.addSubview(graphItem)
        NSLayoutConstraint.activate([
            graphItem.widthAnchor.constraint(equalTo: chartView.widthAnchor, multiplier: widthMultiplier),
            graphItem.heightAnchor.constraint(equalTo: chartView.heightAnchor, multiplier: 218/242),
            graphItem.leftAnchor.constraint(equalTo: leftAnchor),
            graphItem.topAnchor.constraint(equalTo: chartView.topAnchor)
        ])
        graphItems.append(graphItem)
        
        return graphItem.rightAnchor
    }
    
    func refresh(_ dataSource: DataSourceDay) {
        var chartData: [ChartDataEntry] = []
        var i: Int = 0
        var max: Float = 0
        var min: Float = 0
        self.dataSource = dataSource
        let dayData = dataSource.getDayData()
        
        for hour in dayData.forecast {
            chartData.append(ChartDataEntry(x: Double(i), y: Double(hour.main.temp)))
            
            if max < dayData.forecast[i].main.temp {
                max = dayData.forecast[i].main.temp
            }
            
            if min > dayData.forecast[i].main.temp {
                min = dayData.forecast[i].main.temp
            }
            
            i += 1
        }
        
        chartView.leftAxis.axisMaximum = Double(max * 1.5)
        chartView.leftAxis.axisMinimum = Double(min - 1)
        setupChart(chartData)
        graphItemsCollectionView.reloadData()
    }
}

extension UIGraph: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        chartView.moveViewToX(Double( scrollView.contentOffset.x / (graphItemsCollectionView.bounds.width / CGFloat( dataSource?.getDayData().forecast.count ?? 1))))
    }
    
}

extension UIGraph: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UIGraphItem", for: indexPath) as! UIGraphItem
        cell.setup()
        return cell
    }
    
    
}
