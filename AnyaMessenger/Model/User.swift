//
//  User.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/14/23.
//

import FirebaseFirestoreSwift

/**
 Decodable protocol allows to access the database dictionary and matches the entries directly and automatically
 This erases the additionary step of manually caching the new data that parses through the key-vale structure
 */
struct User: Identifiable, Hashable, Decodable {
    @DocumentID var id: String?
    let username: String
    let email: String
    var fullname: String
    var profileImageUrl: String
    var status: UserStatus
    var fcmToken: String?
    
    var isCurrentUser: Bool { return AuthSceneModel.shared.userSession?.uid == id }
}

/**
 Enum defination relies on the User Status model containing and processing values of the same integer values.
 Codable defination indicates that instances of this enum can be encoded to and decoded from different external representations l(eg JSON and Firebase).
 CaseIterable defination indicates that r the generation of a collection that contains all of the enumeration's cases.
 */
enum UserStatus: Int, CaseIterable, Codable {
    case notConfigured
    case available
    case busy
    case school
    case movies
    case work
    case batteryLow
    case meeting
    case gym
    case sleeping
    case urgentCallsOnly
    
    var description: String {
        switch self {
        case .notConfigured: return "Click here to update your status"
        case .available: return "Available"
        case .busy: return "Busy"
        case .school: return "At school"
        case .movies: return "At the movies"
        case .work: return "At work"
        case .batteryLow: return "Battery about to die"
        case .meeting: return "In a meeting"
        case .gym: return "At the gym"
        case .sleeping: return "Sleeping"
        case .urgentCallsOnly: return "Urgent calls only"
        }
    }
}
