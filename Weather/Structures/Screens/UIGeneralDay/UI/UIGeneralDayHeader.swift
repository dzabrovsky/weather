import UIKit

class UIGeneralDayHeader: UIHeader {

    let openMapButton: UIHeaderButton = {
        let headerButton = UIHeaderButton(4)
        headerButton.translatesAutoresizingMaskIntoConstraints = false
        headerButton.icon.image = #imageLiteral(resourceName: "outline_place_black_48pt")
        headerButton.layer.cornerRadius = 8 * screenScale
        return headerButton
    }()
    
    let themeButton: UIHeaderButton = {
        let headerButton = UIHeaderButton(4)
        headerButton.translatesAutoresizingMaskIntoConstraints = false
        headerButton.icon.image = #imageLiteral(resourceName: "outline_light_mode_black_48pt")
        headerButton.layer.cornerRadius = 8 * screenScale
        return headerButton
    }()

    let cityListButton: UIHeaderButton = {
        let headerButton = UIHeaderButton(4)
        headerButton.translatesAutoresizingMaskIntoConstraints = false
        headerButton.icon.image = #imageLiteral(resourceName: "outline_search_black_48pt")
        headerButton.layer.cornerRadius = 8 * screenScale
        return headerButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        
        backgroundColor = UIColor.init(named: "background")
        translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(openMapButton)
        self.addSubview(themeButton)
        self.addSubview(cityListButton)
        
        openMapButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        openMapButton.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        openMapButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        openMapButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        cityListButton.heightAnchor.constraint(equalTo: openMapButton.heightAnchor).isActive = true
        cityListButton.widthAnchor.constraint(equalTo: openMapButton.widthAnchor).isActive = true
        cityListButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16 * screenScale).isActive = true
        cityListButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        themeButton.heightAnchor.constraint(equalTo: openMapButton.heightAnchor).isActive = true
        themeButton.widthAnchor.constraint(equalTo: openMapButton.widthAnchor).isActive = true
        themeButton.rightAnchor.constraint(equalTo: cityListButton.leftAnchor, constant: -8  * screenScale).isActive = true
        themeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
}
