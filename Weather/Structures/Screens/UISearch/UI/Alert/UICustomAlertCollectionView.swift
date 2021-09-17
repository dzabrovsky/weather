//
//  UICustomAlertCollectionView.swift
//  Weather
//
//  Created by Denis Zabrovsky on 02.09.2021.
//

import UIKit

class UICustomAlertCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let cities: [String] = ["Москва", "Санкт-Петербург", "Екатеринбург", "Минск", "Тамбов", "Липецк", "Воронеж"]
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.itemSize = CGSize(width: 50, height: 32)
        super.init(frame: frame, collectionViewLayout: flowLayout)
        self.showsHorizontalScrollIndicator = false
        register(UICustomAlertCollectionViewCell.self, forCellWithReuseIdentifier: "UICustomAlertCollectionViewCell")
        delegate = self
        dataSource = self
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        
        self.backgroundColor = .clear
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: "UICustomAlertCollectionViewCell", for: indexPath) as! UICustomAlertCollectionViewCell
        cell.text.text = cities[indexPath.row]
        
        return cell
    }
    
}
