//
//  SelectableUser.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/21/23.
//

import Foundation

/**
 Generates a unique identifier for a user based on whether the user has been selected 
 */
struct SelectableUser: Identifiable {
    var user: User
    var isSelected: Bool
    
    var id: String {
        return user.id ?? NSUUID().uuidString
    }
}
