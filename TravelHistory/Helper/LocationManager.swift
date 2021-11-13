//
//  LocationManager.swift
//  TravelHistory
//
//  Created by Cepl on 13/11/21.
//
import Foundation
import CoreLocation
enum LocationAccuracy {
    case accuracyBest, accuracyBestForNavigation
    var clLocationAccuracy: CLLocationAccuracy {
        switch self {
        case .accuracyBest: return kCLLocationAccuracyBest
        case .accuracyBestForNavigation: return kCLLocationAccuracyBestForNavigation
        }
    }
}
class LocationManager: NSObject {

    static let sharedInstance = LocationManager()

    private var locationManager: CLLocationManager!

     let geocoder = CLGeocoder()

    private var startTrackingHandler: (_ location: (latitude: Double, longitude: Double)) -> Void = {_ in}
    private var startRangingHandler: (_ beacons: [CLBeacon]) -> Void = {_ in}

    var seenError: Bool = false
    var locationFixAchieved: Bool = false
    var locationStatus: NSString = "Not Started"
    var beaconRegion: CLBeaconRegion!
    private var validationCompletion: (() -> Void)?
    private override init() {
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        //        locationManager?.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() { self.startTracking() }
    }

    func startTracking(_ completion: @escaping (_ location: (latitude: Double, longitude: Double)) -> Void) {
        seenError = false
        locationFixAchieved = false
        startTrackingHandler = completion
        startTracking()
    }
    func startRanging(_ completion: @escaping (_ beacons: [CLBeacon]) -> Void) {
        startRangingHandler = completion
    }

    func isLocationAuthorisationStatusGiven() -> Bool {
        print("isLocationAuthorisationStatusGiven() called \(CLLocationManager.authorizationStatus())")
           if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
               return true
           } else {
               return false
           }
       }
    func isLocationAuthorisationStatusGivenV2(_ completion: @escaping (() -> Void)) -> Bool {
        print("isLocationAuthorisationStatusGivenV2() called \(CLLocationManager.authorizationStatus())")
        validationCompletion = completion
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            return true
        } else {
            return false
        }
    }
    func isLocationServiceStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    func retreiveCityName(latitude: Double, longitude: Double, completionHandler: @escaping (GeoLocation) -> Void) {
        geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { (placeMarks, error) in
            if let placeMark = placeMarks?.first {
                let geoLocation = GeoLocation(with: placeMark)
                completionHandler(geoLocation)
            }
        }
    }

    func setDesiredAccuracy(_ locationAccuracy: LocationAccuracy) {
        locationManager.desiredAccuracy = locationAccuracy.clLocationAccuracy
    }

    func allowBackgroundLocation(updates: Bool) {
        locationManager.allowsBackgroundLocationUpdates = updates
    }

    func setPauseLocationUpdatesAutomatically(_ status: Bool) {
        locationManager.pausesLocationUpdatesAutomatically = status
    }

    func setDistanceFilter(_ distanceInMeters: CLLocationDistance) {
        locationManager.distanceFilter = distanceInMeters
    }

    private func startTracking() {
        locationManager.startUpdatingLocation()
    }

    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
}
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.stopTracking()
        if (error as NSError).domain == kCLErrorDomain && (error as NSError).code == CLError.Code.denied.rawValue {
            if seenError == false {
                seenError = true
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("LocationManager: didUpdateLocations")
        if locationManager.allowsBackgroundLocationUpdates {
            guard let location = locations.last else { return }
            startTrackingHandler((Double(location.coordinate.latitude), Double(location.coordinate.longitude)))
        } else if locationFixAchieved == false {
            locationFixAchieved = true
            guard let location = locations.last else { return }
            startTrackingHandler((Double(location.coordinate.latitude), Double(location.coordinate.longitude)))
            self.stopTracking()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
//            beaconNeedToMonitor()
            validationCompletion?()
        }
    }
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false
        switch status {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.notDetermined:
            locationStatus = "Status not determined"
        case .authorizedAlways: beaconNeedToMonitor()
        case .authorizedWhenInUse: beaconNeedToMonitor()
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        if shouldIAllow == true { self.startTracking() } else { print("Denied access: \(locationStatus)") }
    }
    private func beaconNeedToMonitor() {
        if CLLocationManager.isMonitoringAvailable(for:
            CLBeaconRegion.self) {
            // Match all beacons with the specified UUID
            let proximityUUID = UUID(uuidString:
                "2f234454-cf6d-4a0f-adf2-f4911ba9ffa6")!
            let beaconID = "com.usapp.monitorRegion"

            // Create the region and begin monitoring it.
            beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, identifier: beaconID)
            locationManager.startMonitoring(for: beaconRegion)
            print("Beacon started monitoring")
        }
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
            print("didEnterRegion()")
            var identifier = ""
            if let beaconRegion = region as? CLBeaconRegion {
                identifier = "\(beaconRegion.proximityUUID.uuidString)" //beaconRegion.identifier
            }
        }
        func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
            print("didExitRegion()")
            var identifier = ""
            if let beaconRegion = region as? CLBeaconRegion {
                identifier = "\(beaconRegion.proximityUUID.uuidString)" //beaconRegion.identifier
            }
        }
        func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
            print("monitoringDidFailFor()")
        }
        func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
            print("didDetermineState()")
            if region is CLBeaconRegion && state == .inside {
                // Start ranging only if the devices supports this service.
                if CLLocationManager.isRangingAvailable(), let beaconRegion = region as? CLBeaconRegion {
                    manager.startRangingBeacons(in: beaconRegion)
                    // Store the beacon so that ranging can be stopped on demand.
    //                beaconsToRange.append(region as! CLBeaconRegion)
                }
            }
        }
        func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
            startRangingHandler(beacons)
        }
}
struct GeoLocation {
    let name: String
    let streetName: String
    let streetNumber: String
    let region: String
    let city: String
    let state: String
    let zipCode: String
    let country: String
    let isoCountryCode: String

    var formattedAddress: String {
        return """
        \(name),
        \(streetNumber) \(streetName),
        \(city), \(state) \(zipCode)
        \(country)
        """
    }

    init(with placemark: CLPlacemark) {
        self.name           = placemark.name ?? ""
        self.streetName     = placemark.thoroughfare ?? ""
        self.streetNumber   = placemark.subThoroughfare ?? ""
        self.city           = placemark.locality ?? ""
        self.region         = placemark.subLocality ?? ""
        self.state          = placemark.administrativeArea ?? ""
        self.zipCode        = placemark.postalCode ?? ""
        self.country        = placemark.country ?? ""
        self.isoCountryCode = placemark.isoCountryCode ?? ""
    }
}
//import Alamofire
//extension LocationManager {
//    static func geocodeLocation(from address: String, _ success: @escaping ((_ geocodingModel: GeocodingModel) -> Void), failure: @escaping ((_ error: Error) -> Void)) {
//        let urlString = "https://maps.googleapis.com/maps/api/geocode/json?address=\(address)&sensor=false&key=\(Constants.googleApiDevelopmentKey)"
//        print("urlString: \(urlString)")
//        Alamofire.request(urlString).validate().responseJSON { (alamofireResponse) in
//            switch alamofireResponse.result {
//            case .success(let json):
//                if let jsonObject = json as? AnyObject {
//                    let geocodingModel = GeocodingModel(jsonObject)
//                    success(geocodingModel)
//                }
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//}
