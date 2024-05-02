//
//  NewMessageViewModel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/14/23.
//

import SwiftUI
import Firebase

//used to get all the users
//unwrap the documents that are a part of the snapshot
//populate the users array above by mapping the data from the database structure into the local array

enum NewMessageConfiguration {
    case chat
    case group
}
//how do i add the user to the sirenlist from this class instead
class NewMessageSceneModel: ObservableObject {
    @Published var users = [User]()
    @Published var selectableUsers = [SelectableUser]()
    @Published var selectedUsers = [SelectableUser]()
    
    init(config: NewMessageConfiguration) {
        fetchUsers(forConfig: config)
    }
    
    func fetchUsers(forConfig config: NewMessageConfiguration) {
        guard let uid = AuthSceneModel.shared.currentUser?.id else { return }
        
        COLLECTION_USERS.whereField("uid", isNotEqualTo: uid).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let users = documents.compactMap({ try? $0.data(as: User.self) })
            
            if config == .chat {
                self.users = users
            } else {
                self.selectableUsers = users.map({ SelectableUser(user: $0, isSelected: false) })
            }
            
        }
    }
    
    func selectUser(_ user: SelectableUser, isSelected: Bool) {
        guard let index = selectableUsers.firstIndex(where: { $0.id == user.id }) else { return }
        
        selectableUsers[index].isSelected = isSelected

        if isSelected {
            selectedUsers.append(selectableUsers[index])
        } else {
            selectedUsers.removeAll(where: { $0.id == user.user.id })
        }
        
    }
    
    func filteredUsers(_ query: String) -> [User] {
        let lowercasedQuery = query.lowercased()
        return users.filter({ $0.fullname.lowercased().contains(lowercasedQuery) || $0.username.contains(lowercasedQuery) })
    }
    
    func addUserToSirenList(userToAddId: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserId = AuthSceneModel.shared.currentUser?.id else {
            completion(false)
            return
        }

        let sirenListRef = COLLECTION_SIRENS.document(currentUserId)
        sirenListRef.updateData([
            "uids": FieldValue.arrayUnion([userToAddId])
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

