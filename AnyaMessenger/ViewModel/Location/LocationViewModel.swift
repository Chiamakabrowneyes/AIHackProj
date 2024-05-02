//
//  LocationViewModel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 11/24/23.
//

import Foundation
import MapKit

enum MapDetails {
    static let startingCoordinate = CLLocationCoordinate2D(latitude: 0.331516, longitude: -11.891052)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

final class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(center: MapDetails.startingCoordinate, span: MapDetails.defaultSpan)
    @Published var errorMessage: String?

    var locationManager: CLLocationManager?
    var user: User

    init(user: User) {
        self.user = user
        super.init()
        checkIfLocationServicesIsEnabled()
    }

    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            checkLocationAuthorization()
        } else {
            errorMessage = "Location services are not enabled."
        }
    }

    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            errorMessage = "Location access is restricted or denied."
        case .authorizedAlways, .authorizedWhenInUse:
            if let currentLocation = locationManager.location?.coordinate {
                region = MKCoordinateRegion(center: currentLocation, span: MapDetails.defaultSpan)
            }
        @unknown default:
            break
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            region = MKCoordinateRegion(center: location, span: MapDetails.defaultSpan)
            
            let latitude = location.latitude
            let longitude = location.longitude
            print("Latitude: \(latitude), Longitude: \(longitude)")
        }
    }

    
    func getCurrentLocation(completion: @escaping (CLLocationCoordinate2D?) -> Void) {
            guard let locationManager = locationManager else {
                completion(nil)
                return
            }
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
            } else {
                errorMessage = "Location services are not enabled."
                completion(nil)
            }
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            // You can use a timer or a delegate method to handle the location update.
            // For this example, we'll use a timer to simulate the update.
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                // Assuming you've waited for a few seconds for the location update.
                if let currentLocation = locationManager.location?.coordinate {
                    completion(currentLocation)
                } else {
                    completion(nil)
                }
                locationManager.stopUpdatingLocation()
            }
        }
    
}
