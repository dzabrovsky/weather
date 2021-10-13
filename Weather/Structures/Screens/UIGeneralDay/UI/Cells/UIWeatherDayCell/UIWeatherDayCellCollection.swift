import UIKit

class UIWeatherDayCellColletion: UICollectionView {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10000
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width*0.2, height: UIScreen.main.bounds.width*0.31)
        
        super.init(frame: CGRect(), collectionViewLayout: layout)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        register(UIHourWeatherCell.self, forCellWithReuseIdentifier: "UIHourWeatherCell")
    }
}
