//
//  LocationManager.swift
//  FourSquareDemo
//
//  Created by Elvis Mwenda on 31/10/2021.
//

import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    // MARK: Lifecycle

    override init() {
        super.init()
    }

    // MARK: Internal

    static var shared = LocationManager()

    private(set) var currentLocation: CLLocation? {
        get {
            return _currentLocation
        }
        set {
            _currentLocation = newValue
        }
    }

    func setupManager() {
        // Locations get
        checkPermission()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startMonitoringSignificantLocationChanges()
        manager.distanceFilter = 0
        manager.startUpdatingLocation()
    }

    func locationManager(_: CLLocationManager, didChangeAuthorization _: CLAuthorizationStatus) {}

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        Logger.shared.log(error, #file, #line)
    }

    // MARK: Private

    private var manager = CLLocationManager()

    private var _currentLocation: CLLocation?

    private func checkPermission() {
        switch manager.authorizationStatus {
        case .denied,
             .notDetermined,
             .restricted:
            manager.requestAlwaysAuthorization()
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways,
             .authorizedWhenInUse:
            currentLocation = manager.location
        @unknown default:
            break
        }
    }
}
