//
//  ChannelsMessageViewModel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/21/23.


import Foundation

struct ChannelMessageSceneModel {
    let message: ChannelTextMessage
    
    var currentUid: String { return AuthSceneModel.shared.userSession?.uid ?? "" }
    
    var isFromCurrentUser: Bool { return message.fromId == currentUid }
    
    var fullname: String {
        return message.user?.fullname ?? ""
    }
}
