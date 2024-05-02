//
//  ChatViewModel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/1/23.
//

//only store messages that aren't from the current logged in user to prevent duplicates and to properly isolate the communication stream.
//injects user in chat view --> create a collection with the chat partners id and populates the messages on each users message DB
//not create a seperate chat message ID for the other communicator since the message is paired with both users and unique.

import SwiftUI
import Firebase
import FirebaseStorage

class EditProfileSceneModel: ObservableObject {
    @Published var user: User
    
    init(user: User) {
        self.user = user
    }
        
    func updateProfileImage(_ image: UIImage) {
        guard let uid = user.id else { return }
        
        Storage.storage().reference(forURL: user.profileImageUrl).delete { _ in
            ImageUploader.uploadImage(image: image, type: .profile) { profileImageUrl in
                COLLECTION_USERS.document(uid).updateData(["profileImageUrl": profileImageUrl]) { _ in
                    self.user.profileImageUrl = profileImageUrl
                }
            }
        }
    }
    
    func updateName(_ name: String) {
        guard let uid = user.id else { return }
        COLLECTION_USERS.document(uid).updateData(["fullname": name]) { _ in
            self.user.fullname = name
        }
    }
    
    func updateUserStatus(_ status: UserStatus) {
        guard let uid = user.id else { return }
        COLLECTION_USERS.document(uid).updateData(["status": status.rawValue]) { _ in
            self.user.status = status
        }
    }
}
