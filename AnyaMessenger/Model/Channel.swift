//
//  Channel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/21/23.
//

import FirebaseFirestoreSwift

/**
 Creating the model for the channel which would holds relevant data for the channel such as: the users, channel name, etc.
 */
struct Channel: Identifiable, Decodable {
    @DocumentID var id: String?
    var name: String
    var imageUrl: String?
    var uids: [String]
    var lastMessage: String
}
