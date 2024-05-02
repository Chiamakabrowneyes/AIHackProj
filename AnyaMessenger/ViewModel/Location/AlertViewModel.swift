//
//  ObserveAlertModel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 1/13/24.
//

import Foundation
import Firebase

class AlertViewModel: ObservableObject {
    

    func updateSirenData(riskTypes: [String], latitudes: Double?, longitudes: Double?) {
        guard let currentUid = AuthSceneModel.shared.currentUser?.id else { return }

        // Create a new document in the "sirens" collection with an automatically generated ID
        let newDocumentRef = COLLECTION_ALERTS.addDocument(data: [
            "fromId": currentUid,
            "riskTypes": riskTypes,
            "latitude": latitudes ?? 0.000,
            "longitude": longitudes ?? 0.000,
            "timestamp": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
            }
        }
    }
    
    
    
}
