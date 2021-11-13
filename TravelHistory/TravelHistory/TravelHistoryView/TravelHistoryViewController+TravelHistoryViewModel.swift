//
//  TravelHistoryViewController+TravelHistoryViewModel.swift
//  TravelHistory
//
//  Created by Cepl on 13/11/21.
//
import Foundation
import UIKit
extension TravelHistoryViewController: TravelHistoryViewModelDelegate {
    func getCurrentLocationSuccessResponse() {
        setupActivityIndicator(true)
    }
    func getCurrentLocationFailureResponse() {
        setupActivityIndicator(true)
        showErrorAlert("Unable to update the your location.")
    }
     func showErrorAlert(_ message: String) {
       print(message)
    }
}
