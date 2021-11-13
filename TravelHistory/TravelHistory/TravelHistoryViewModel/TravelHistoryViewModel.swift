//
//  TravelHistoryViewModel.swift
//  TravelHistory
//
//  Created by Cepl on 13/11/21.
//
import Foundation
import Alamofire
import UIKit
protocol TravelHistoryViewModelProtocol {
    func getCurrentLocation(_ lat: Double, _ long: Double)
    var delegate: TravelHistoryViewModelDelegate? { get set }
}
protocol TravelHistoryViewModelDelegate: class {
    func getCurrentLocationSuccessResponse()
    func getCurrentLocationFailureResponse()
}
class TravelHistoryViewModel: TravelHistoryViewModelProtocol {
    var delegate: TravelHistoryViewModelDelegate?
    var travelHistoryModel: TravelHistoryModel?
    func getCurrentLocation(_ lat: Double, _ long: Double) {
        let url = "https://nominatim.openstreetmap.org/reverse?format=json&lat=\(lat)&lon=\(long)"
        Alamofire.request(url, method: .get).response { (defaultDataResponse) in
            guard let data = defaultDataResponse.data else { return }
            print("location info :",data)
            do {
                let travelHistoryModel = try JSONDecoder().decode(TravelHistoryModel.self, from: data)
                self.travelHistoryModel = travelHistoryModel
                self.delegate?.getCurrentLocationSuccessResponse()
            } catch {
                self.delegate?.getCurrentLocationFailureResponse()
            }
        }
    }
}
