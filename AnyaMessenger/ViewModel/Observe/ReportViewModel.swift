//
//  ReportViewModel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 2/16/24.
//

import SwiftUI
import Firebase
import CoreLocation

class ReportViewModel: ObservableObject {
    let user : User
    @ObservedObject var locationViewModel: LocationViewModel
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var address: String?
    @Published var reports: [Report] = []
    @State private var geocoder = CLGeocoder()
    
    
    init(user: User) {
        self.user = user
        self.locationViewModel = LocationViewModel(user: user)
    }
    
    private func addReportToDatabase(reportText: String) {
        guard let _ = AuthSceneModel.shared.currentUser?.id else { return }
        
        // Proceed with adding the report now that address is guaranteed to be fetched
        let newDocumentRef = COLLECTION_REPORTS.addDocument(data: [
            "reportText": reportText,
            "address": address ?? "",
            "timestamp": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
            }
        }
    }
    
    func addReport(reportText: String) {
        guard let currentUid = AuthSceneModel.shared.currentUser?.id else { return }

        fetchLocation {
            // Ensure latitude and longitude are not nil before fetching address
            if let latitude = self.latitude, let longitude = self.longitude {
                self.fetchAddress(latitude: latitude, longitude: longitude) {
                    // Now that we have the address, continue with adding the report
                    self.addReportToDatabase(reportText: reportText)
                }
            }
        }
    }

    

    
    func fetchLocation(completion: (() -> Void)? = nil) {
        self.getLocationData { [weak self] lat, long in
            DispatchQueue.main.async {
                self?.latitude = lat
                self?.longitude = long
                completion?() // Call completion if location fetch was successful
            }
        }
    }

    
    func fetchAddress(latitude: Double, longitude: Double, completion: @escaping () -> Void) {
        getReverseGeocode(latitude: latitude, longitude: longitude) { [weak self] address in
            DispatchQueue.main.async {
                self?.address = address
                completion() // Indicate completion
            }
        }
    }
    
    func getLocationData(completion: @escaping (Double?, Double?) -> Void) {
        locationViewModel.getCurrentLocation { [weak self] location in
            guard let self = self else { return }

            if let location = location {
                let latitude = location.latitude
                let longitude = location.longitude
                completion(latitude, longitude)
            } else {
                print("Failed to retrieve location.")
                completion(nil, nil)
            }
        }
    }
    
    func getReverseGeocode(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                completion(nil)
            } else if let placemark = placemarks?.first {
                // Extract address information from the placemark
                let address = "\(placemark.locality ?? "") \(placemark.administrativeArea ?? "") \(placemark.country ?? "")"
                completion(address)
            } else {
                completion(nil)
            }
        }
    }
    
    
    func fetchReports() {
            COLLECTION_REPORTS.addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.reports = documents.map { queryDocumentSnapshot -> Report in
                    let data = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    return Report(id: id, data: data)
                }
            }
        }
    
}
