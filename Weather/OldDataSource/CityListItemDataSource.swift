import Foundation

protocol CityListItemDataSourceProtocol {
    func getCityList() -> [CityListItem]
    func getCityListByIndexInArray(_ index: Int) -> CityListItem
}
class CityListItemDataSource: CityListItemDataSourceProtocol {
    var data: [CityListItem] = []
    
    func getCityList() -> [CityListItem] {
        return data
    }
    func getCityListByIndexInArray(_ index: Int) -> CityListItem {
        return data[index]
    }
}
