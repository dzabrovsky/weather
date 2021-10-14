import UIKit

class UIWeatherDayCell: UITableViewCellWithWaiter {
    
    private let adapter: GeneralDayForecastDayAdapter = GeneralDayForecastDayAdapter()
    
    private let header: UIWeatherDayCellHeader = {
        let header = UIWeatherDayCellHeader()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    private let underline: UIView = {
        let underline = UIView()
        underline.backgroundColor = UIColor.init(named: "underline")
        underline.translatesAutoresizingMaskIntoConstraints = false
        
        return underline
    }()
    
    private let collectionView = UIWeatherDayCellColletion()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        layoutHeader()
        layoutCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(){
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = UIColor.init(named: "tv_cell_background")
        contentView.layer.cornerRadius = 16 * screenScale
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8 * screenScale)
        ])
        
        contentView.addSubviews([
            header,
            underline,
            collectionView
        ])
        
        collectionView.dataSource = adapter
        header.dataSource = adapter
    }
    
    private func layoutHeader() {
        NSLayoutConstraint.activate([
            header.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 60/343),
            header.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            header.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            header.topAnchor.constraint(equalTo: contentView.topAnchor),
            underline.topAnchor.constraint(equalTo: header.bottomAnchor),
            underline.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 303/343),
            underline.heightAnchor.constraint(equalToConstant: screenScale),
            underline.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func layoutCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 24 * screenScale),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16 * screenScale),
            collectionView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 114/343)
        ])
    }
    
    func refresh(_ data: ForecastDay) {
        isWaiterActive = false
        adapter.setData(data)
        header.reloadData()
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isWaiterActive {
            drawWaiter(bounds: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - 8 * screenScale), cornerRadius: contentView.layer.cornerRadius)
        }else{
            hideWaiter()
        }
    }
}
