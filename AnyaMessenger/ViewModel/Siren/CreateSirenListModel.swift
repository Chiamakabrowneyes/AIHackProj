//
//  CreateSirenListModel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 11/7/23.
//

import UIKit
import FirebaseFirestore


class CreateSirenListModel: ObservableObject {
    let users: [User]
    
    init(users: [User]) {
        self.users = users
    }
    
    func createSirenList(name: String, completion: @escaping (Bool, String?) -> Void) {
        guard let currentUser = AuthSceneModel.shared.currentUser,
              let currentUid = currentUser.id else {
            completion(false, nil)
            return
        }

        // We start with just the name of the list and the creator's UID.
        let data: [String: Any] = [
            "name": name,
            "creator": currentUid, // Here is where you set the 'creator' field
            "uids": [String]()    // An empty array of user IDs to start wit
        ]
        
        let newDocument = COLLECTION_SIRENS.document()  // Create a reference to a new document.
        newDocument.setData(data) { error in
            if let error = error {
                print("Error creating siren list: \(error)")
                completion(false, nil)
            } else {
                completion(true, newDocument.documentID)  // Return the new document ID.
            }
        }
    }
    
    func addUserToSirenList(documentId: String, userId: String, completion: @escaping (Bool) -> Void) {
        let sirenListRef = COLLECTION_CHANNELS.document(documentId)
        sirenListRef.updateData([
            "uids": FieldValue.arrayUnion([userId])
        ]) { error in
            if let error = error {
                print("Error adding user to siren list: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
