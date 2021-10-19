import UIKit

class AutoCompletionCityNameAdapter: NSObject {
    
    private var data: SearchResults?
    
    private let textField: UITextField
    private let collectionView: UICollectionView
    
    init(textField: UITextField, collectionView: UICollectionView) {
        self.textField = textField
        self.collectionView = collectionView
    }
    
    func refreshData(_ data: SearchResults){
        self.data = data
        collectionView.reloadData()
    }
}

extension AutoCompletionCityNameAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = data else { return }
        textField.text = data.results[indexPath.row]
    }
}

extension AutoCompletionCityNameAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = data else { return 0 }
        return data.totalResults
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = data else { return UICollectionViewCell()}
        let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "UICustomAlertCollectionViewCell",
                for: indexPath) as! UICustomAlertCollectionViewCell
        cell.text.text = data.results[indexPath.row]
        return cell
    }
}
