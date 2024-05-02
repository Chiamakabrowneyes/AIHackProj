//
//  ForecastModel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 1/10/24.
//

import Foundation
import FirebaseFirestore

struct Report: Identifiable {
    var id: String
    var reportText: String
    var address: String
    var timestamp: Date // Assuming you have a timestamp field

    // Initialize from a Firestore document
    init(id: String, data: [String: Any]) {
        self.id = id
        self.reportText = data["reportText"] as? String ?? ""
        self.address = data["address"] as? String ?? ""
        // Make sure to convert the timestamp from Firestore to Date
        let timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.timestamp = timestamp.dateValue()
    }
}


