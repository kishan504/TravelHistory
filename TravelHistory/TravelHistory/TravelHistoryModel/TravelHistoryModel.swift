//
//  TravelHistoryModel.swift
//  TravelHistory
//
//  Created by Cepl on 13/11/21.
//
import Foundation
import UIKit
import Alamofire
import Realm
import RealmSwift
class TravelHistoryModel: Object, Decodable {
    @objc dynamic var placeId: Int
    @objc dynamic var licence: String
    @objc dynamic var osmType: String
    @objc dynamic var osmId: Int
    @objc dynamic var lat: String
    @objc dynamic var lon: String
    @objc dynamic var displayName: String
    @objc dynamic var addressDetail: AddressDetail?
    var boundingbox: [String]
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case licence
        case osmType = "osm_type"
        case osmId = "osm_id"
        case lat
        case lon
        case displayName = "display_name"
        case addressDetail = "address_detail"
        case boundingbox
    }
}
class AddressDetail: Object, Decodable {
    @objc dynamic var railway: String
    @objc dynamic var road: String
    @objc dynamic var suburb: String
    @objc dynamic var city: String
    @objc dynamic var municipality: String
    @objc dynamic var county: String
    @objc dynamic var stateDistrict: String
    @objc dynamic var state: String
    @objc dynamic var postcode: String
    @objc dynamic var country: String
    @objc dynamic var countryCode: String
    private enum CodingKeys: String, CodingKey {
        case railway
        case road
        case suburb
        case city
        case municipality
        case county
        case stateDistrict = "state_district"
        case state
        case postcode
        case country
        case countryCode = "country_code"
    }
}
