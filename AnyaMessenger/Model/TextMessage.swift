//
//  Message.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/1/23.
//


import FirebaseFirestoreSwift
import Firebase

//Struct to initialize the data that would be stored in the text message
struct TextMessage: Identifiable, Decodable{
    let id: String
    let fromId: String
    let toId: String
    let timestamp: Timestamp
    let text: String
    var user: User?
    var read: Bool
    var imageUrl: String?
}

//Struct to initialize the data that would be stored in the text message
struct ChannelTextMessage: Identifiable, Decodable {
    @DocumentID var id: String?
    let fromId: String
    let timestamp: Timestamp
    let text: String
    var user: User?
}



