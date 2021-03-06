import UIKit

class UIDayDetailsView: UIView {
    
    let header = UIHeader()
    
    let tableView: UIDayDetailsTableView = {
        let tableView = UIDayDetailsTableView()
        tableView.setup()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        self.backgroundColor = UIColor.init(named: "background")
        self.addSubview(header)
        self.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            header.leftAnchor.constraint(equalTo: self.leftAnchor),
            header.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            header.rightAnchor.constraint(equalTo: self.rightAnchor),
            header.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 64/375),
            
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 4),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
