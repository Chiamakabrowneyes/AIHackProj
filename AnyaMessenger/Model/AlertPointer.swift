//
//  AlertData.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 1/13/24.
//

import FirebaseFirestoreSwift
import Firebase


//TODO: Create a struct for siren calls. which would contain the same data as a text message including some more unique info; eg location data.

struct AlertPointer: Identifiable, Decodable  {
    var id: String?
    let fromId: String
    var latitude: Double?
    var longitude:Double?
    var riskTypes: [String]
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
            case id
            case fromId
            case latitude
            case longitude
            case riskTypes
            case timestamp
        }
}
