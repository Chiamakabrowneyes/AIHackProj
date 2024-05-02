//
//  ConversationsViewModel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/21/23.
//

import SwiftUI

/**
 This view model handles the display of text messages when users are interacting one-on-one by
 fetching the most recent messages for the currently authenticated user from a Firestore database.
 */
class ConversationsSceneModel: ObservableObject {
    @Published var recentMessages = [TextMessage]()
    private var recentMessagesDictionary = [String: TextMessage]()
    
    init() {
        //Calls method to retrieve all messages from firestore database
        fetchRecentMessages()
    }
    func fetchRecentMessages() {
        //Gets the user Uid based on data from the active user session
        guard let uid = AuthSceneModel.shared.userSession?.uid else { return }
        
        
        //sets up a Firestore query targeting the "recent-messages" sub-collection inside a document whose ID matches the authenticated user's UID in the COLLECTION_MESSAGES collection
        let query = COLLECTION_MESSAGES.document(uid).collection("recent-messages")
        query.order(by: "timestamp", descending: false)
        
        //document retrival call to get the recent messages from firestore in a descending order as document is stored in snapshot
        query.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            //for the message document collection, we will isolate the data points
            documents.forEach { document in
                let uid = document.documentID
                guard var message = try? document.data(as: TextMessage.self) else { return }
                
                //based on the user data point in the message object, we will be able to add that user to the array of messages
                COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
                    guard let user = try? snapshot?.data(as: User.self) else { return }
                    message.user = user
                    self.recentMessagesDictionary[uid] = message
                    //sorts the users according to the ones that have recieved messages more recently
                    self.recentMessages = Array(self.recentMessagesDictionary.values)
                        .sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue()})
                }
            }
        }
    }
    
    
}
