import UIKit

class CityListAdapter: NSObject {
    private var data: [CityWeather] = []
    
    var tapDelegate: TapCellGestureDelegate?
    var swipeDelegate: SwipeCellGestureDelegate?
    var moveDelegate: MoveCellGestureDelegate?
    
    func addData(_ data: CityWeather){
        self.data.append(data)
    }
    
    func removeCityList(){
        data.removeAll()
    }
    
    func removeCityAt(index: Int){
        data.remove(at: index)
    }
    
    private func addGestureToCell(cell: UITableViewCell, indexPath: IndexPath){
        
        let tapGesture = TapCellGesture(
            target: self,
            action: nil,
            row: indexPath.row
        )
        tapGesture.tapDelegate = tapDelegate
        
        let swipeGesture = SwipeCellGesture(
            target: self,
            action: nil,
            index: data[indexPath.row].index,
            row: indexPath.row,
            cell: cell
        )
        swipeGesture.swipeDelegate = swipeDelegate
        
        if let moveDelegate = moveDelegate {
            let moveGesture = MoveCellGesture(
                target: self,
                action: nil,
                row: indexPath.row,
                cell: cell,
                moveDelegate: moveDelegate
            )
            cell.addGestureRecognizer(moveGesture)
        }
        
        cell.addGestureRecognizer(tapGesture)
        cell.addGestureRecognizer(swipeGesture)
    }
}

extension CityListAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UICityListTableViewCell", for: indexPath) as! UICityListTableViewCell
        
        let city = data[indexPath.row]
        
        addGestureToCell(cell: cell, indexPath: indexPath)
        cell.cityName.text = city.name
        cell.temp.text = city.temp
        cell.tempFeelsLike.text = city.feelsLike
        cell.icon.image = city.icon
        
        return cell
    }
}
