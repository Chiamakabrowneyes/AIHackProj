//
//  MessageViewModel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/21/23.
//

import Foundation

struct MessageSceneModel {
    let message: TextMessage
    
    var currentUid: String { return AuthSceneModel.shared.userSession?.uid ?? "" }
    
    var isFromCurrentUser: Bool { return message.fromId == currentUid }
    
    var isImageMessage: Bool { return message.imageUrl != nil }
    
    var profileImageUrl: URL? {
        return URL(string: message.user?.profileImageUrl ?? "")
    }
    
    var messageImageUrl: URL? {
        guard let imageUrl = message.imageUrl else { return nil }
        return URL(string: imageUrl)
    }
    
    var fullname: String {
        return message.user?.fullname ?? ""
    }
}
