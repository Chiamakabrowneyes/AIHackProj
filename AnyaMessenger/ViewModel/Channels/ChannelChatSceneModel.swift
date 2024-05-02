//
//  ChannelChatViewModel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/21/23.
//

import Firebase

class ChannelChatSceneModel: ObservableObject {
    @Published var messages = [ChannelTextMessage]()
    @Published var messageToSetVisible: String?
    private var users = [User]()
    let channel: Channel
    
    init(channel: Channel) {
        self.channel = channel
        fetchMessages()
    }
    
    func sendMessage(messageText: String) {
        guard let currentUser = AuthSceneModel.shared.currentUser else { return }
        guard let currentUid = currentUser.id else { return }
        guard let channelId = channel.id else { return }
        
        let data: [String: Any] = ["text": messageText,
                                   "fromId": currentUid,
                                   "timestamp": Timestamp(date: Date())]
        
        COLLECTION_CHANNELS.document(channelId).collection("messages").document().setData(data)
        COLLECTION_CHANNELS.document(channelId).updateData(["lastMessage": "\(currentUser.fullname): \(messageText)"])
    }
    
    func fetchMessages() {
        guard let channelId = channel.id else { return }
        guard let currentUid = AuthSceneModel.shared.currentUser?.id else { return }
                
        let query = COLLECTION_CHANNELS
            .document(channelId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
        
        query.addSnapshotListener { snapshot, error in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            let messages = changes.compactMap({ try? $0.document.data(as: ChannelTextMessage.self) })
            
            self.messages.append(contentsOf: messages)
                        
            for (index, message) in self.messages.enumerated() where message.fromId != currentUid {
                
                if let index = self.users.firstIndex(where: { $0.id == message.fromId }) {
                    print("DEBUG: Found user \(self.users[index].username)")
                    self.messages[index].user = self.users[index]
                } else {
                    UserService.fetchUser(withUid: message.fromId) { user in
                        print("DEBUG: Did fetch user \(user)")
                        self.users.append(user)
                        self.messages[index].user = user
                        self.messageToSetVisible = self.messages.last?.id
                    }
                }
            }
        }
    }
}
