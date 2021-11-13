//
//  TravelHistoryModel.swift
//  TravelHistory
//
//  Created by Cepl on 13/11/21.
//
import Foundation
struct TravelHistoryModel: Codable {
    @DecodableDefault.EmptyInt var placeId: Int
    @DecodableDefault.EmptyString var licence: String
    @DecodableDefault.EmptyString var osmType: String
    @DecodableDefault.EmptyInt var osmId: Int
    @DecodableDefault.EmptyString var lat: String
    @DecodableDefault.EmptyString var lon: String
    @DecodableDefault.EmptyString var displayName: String
    var addressDetail: AddressDetail
    @DecodableDefault.EmptyList var boundingbox: [String]
    
    private enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case licence
        case osmType = "osm_type"
        case osmId = "osm_id"
        case lat
        case lon
        case displayName = "display_name"
        case addressDetail
    }
}
struct AddressDetail: Codable {
    var railway:String
    var road:String
    var suburb:String
    var city:String
    var municipality: String
    var county: String
    var stateDistrict: String
    var state: String
    var postcode: String
    var country: String
    var countryCode: String
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
