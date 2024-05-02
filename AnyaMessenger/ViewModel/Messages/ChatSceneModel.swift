//
//  ChatViewModel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/21/23.
//

import SwiftUI
import Firebase

enum MessageType {
    case text(String)
    case image(UIImage)
}

class ChatSceneModel: ObservableObject {
    let user: User
    
    @Published var messages = [TextMessage]()
    @Published var messageToSetVisible: String?
    
    init(user: User) {
        self.user = user
        fetchMessages()
    }
    
    func fetchMessages() {
        guard let currentUid = AuthSceneModel.shared.userSession?.uid else { return }
        guard let uid = user.id else { return }
                
        let query = COLLECTION_MESSAGES
            .document(currentUid)
            .collection(uid)
            .order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == DocumentChangeType.added }) else { return }
            let newMessages = changes.compactMap({ try? $0.document.data(as: TextMessage.self) })
            
            // Prepend the new messages to the beginning of the messages array
            self.messages.insert(contentsOf: newMessages, at: 0)
            
            for (index, message) in self.messages.enumerated() where message.fromId != currentUid {
                self.messages[index].user = self.user
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.messageToSetVisible = self.messages.last?.id
                }
            }
        }
    }

    
    func send(type: MessageType) {
        switch type {
        case .text(let messageText):
            sendMessage(messageText)
            
        case .image(let image):
            ImageUploader.uploadImage(image: image, type: .message) { imageUrl in
                self.sendMessage("Attachment: 1 image", imageUrl)
            }
        }
    }
    
    private func sendMessage(_ messageText: String, _ imageUrl: String? = nil) {
        guard let currentUid = AuthSceneModel.shared.currentUser?.id else { return }
        guard let uid = user.id else { return }
        
        let currentUserRef = COLLECTION_MESSAGES.document(currentUid).collection(uid).document()
        let receivingUserRef = COLLECTION_MESSAGES.document(uid).collection(currentUid)
        let receivingRecentRef = COLLECTION_MESSAGES.document(uid).collection("recent-messages")
        let currentRecentRef =  COLLECTION_MESSAGES.document(currentUid).collection("recent-messages")
        
        let messageID = currentUserRef.documentID
        
        var data: [String: Any] = ["text": messageText,
                                   "id": messageID,
                                   "fromId": currentUid,
                                   "toId": uid,
                                   "read": false,
                                   "timestamp": Timestamp(date: Date())]
        
        if let imageUrl = imageUrl {
            data["imageUrl"] = imageUrl
        }
        
        currentUserRef.setData(data)
        currentRecentRef.document(uid).setData(data)

        receivingUserRef.document(messageID).setData(data)
        receivingRecentRef.document(currentUid).setData(data)
    }
}
