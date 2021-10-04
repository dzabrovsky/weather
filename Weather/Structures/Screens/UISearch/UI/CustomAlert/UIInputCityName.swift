import UIKit

class UIInputCityName: UIViewController {
    
    private let k: CGFloat = UIScreen.main.bounds.width / 375
    
    private var citiesCompletionData: SearchResults = SearchResults(totalResults: 0, results: [])
    
    let completion: (String) -> Void
    
    let alert: UICustomAlert = {
        let alert = UICustomAlert()
        alert.translatesAutoresizingMaskIntoConstraints  = false
        
        return alert
    }()
    
    init(completion: @escaping (String) -> Void) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setActions()
        addObservers()
        
        alert.inputCityName.becomeFirstResponder()
    }
    
    @objc private func apply(sender: UIButton!){
        self.dismiss(animated: true, completion: { self.completion(self.alert.inputCityName.text ?? "") })
    }
    
    @objc private func cancel(sender: UIButton!){
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func onKeyBoardShow(notification: NSNotification) {
        
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        if let keyboardHeight = keyboardSize?.height {
            alert.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight - 30*k).isActive = true
            
            UIView.animate(withDuration: 0.5){
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onKeyBoardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func setActions() {
        alert.cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        alert.applyButton.addTarget(self, action: #selector(apply), for: .touchUpInside)
    }
    
    private func setup() {
        alert.citiesCollectionView.dataSource = self
        alert.citiesCollectionView.delegate = self
        view.backgroundColor = UIColor.init(named: "background_alert")
        
        view.addSubview(alert)
        
        NSLayoutConstraint.activate([
            alert.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 343/375),
            alert.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 180/375),
            alert.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alert.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func refreshAutoCompletion(_ serachResults: SearchResults){
        self.citiesCompletionData = serachResults
        
        alert.citiesCollectionView.reloadData()
    }
}

extension UIInputCityName: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        alert.inputCityName.text = citiesCompletionData.results[indexPath.row]
    }
}

extension UIInputCityName: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return citiesCompletionData.totalResults
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "UICustomAlertCollectionViewCell",
                for: indexPath) as! UICustomAlertCollectionViewCell
        cell.text.text = citiesCompletionData.results[indexPath.row]
        return cell
    }
}
