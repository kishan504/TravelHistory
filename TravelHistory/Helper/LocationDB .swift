//
//  LocationDB .swift
//  TravelHistory
//
//  Created by Cepl on 13/11/21.
//
//import Foundation
//import RealmSwift
//import Realm
//class LocationDB {
//    static let shared = LocationDB()
//    private init() { }
//    func insert(_ location: TravelHistoryModel) {
//        let realm = try? Realm()
//        try! realm?.write {
//            realm?.add(location)
//        }
//    }
//    func fetch() -> [TravelHistoryModel] {
//        let realm = try? Realm()
//        let travelHistoryModel = realm?.objects(TravelHistoryModel.self)
//        var travelHistoryList: [TravelHistoryModel] = []
//        if let travelHistory = travelHistoryModel {
//            for item in travelHistory {
//                travelHistoryList.append(item)
//            }
//        }
//        return travelHistoryList
//    }
//}
