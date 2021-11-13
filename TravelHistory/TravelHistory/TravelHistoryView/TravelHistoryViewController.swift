//
//  TravelHistoryViewController.swift
//  TravelHistory
//
//  Created by Cepl on 13/11/21.
//
import UIKit
class TravelHistoryViewController: UIViewController {
    @IBOutlet var travelHistoryView: TravelHistoryView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var travelHistoryViewModel: TravelHistoryViewModelProtocol = TravelHistoryViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTravelHistoryView()
        setupTravelHistoryViewModel()
        getLocationUpdates()
    }
    private func setupTravelHistoryView() {
        travelHistoryView.setupTravelHistoryView()
    }
    private func setupTravelHistoryViewModel() {
        travelHistoryViewModel.delegate = self
    }
    func setupActivityIndicator(_ enable: Bool) {
        activityIndicator.isHidden = enable
        activityIndicator.isHidden ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
    }
    private func getLocationUpdates() {
        if LocationManager.sharedInstance.isLocationAuthorisationStatusGiven() {
            LocationManager.sharedInstance.startTracking { (location) in
                print("location.latitude: \(location.latitude)")
                setupActivityIndicator(false)
                self.travelHistoryViewModel.getCurrentLocation(location.latitude, location.longitude)
            }
        } else {
            if LocationManager.sharedInstance.isLocationServiceStatus() == .denied {
                print("locationPermissionDenied()")
            } else {
                _ = LocationManager.sharedInstance.isLocationAuthorisationStatusGivenV2 {
                    LocationManager.sharedInstance.startTracking { (location) in
                        print("location.latitude: \(location.latitude)")
                        setupActivityIndicator(false)
                        self.travelHistoryViewModel.getCurrentLocation(location.latitude, location.longitude)
                    }
                }
            }
        }
    }
}
