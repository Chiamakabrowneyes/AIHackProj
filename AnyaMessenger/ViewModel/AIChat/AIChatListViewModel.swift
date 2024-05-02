//
//  AIChatListViewModel.swift
//  AnyaMessenger
//
//  Created by Chiamaka U on 3/2/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import OpenAI

class AIChatListViewModel: ObservableObject {
    
    @Published var chats: [AppChat] = []
    @Published var loadingState: ChatListState = .none
    @Published var isShowingProfileView = false
    private let db = Firestore.firestore()
    
    func fetchData(user: String?) {
        if loadingState == .none {
            loadingState = .loading
            db.collection("aichats").whereField("owner", isEqualTo: user ?? "").addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self, let documents = querySnapshot?.documents, !documents.isEmpty else {
                    self?.loadingState = .noResults
                    return
                }
                
                self.chats = documents.compactMap({ snapshot -> AppChat? in
                    return try? snapshot.data(as: AppChat.self)
                })
                .sorted(by: {$0.lastMessageSent > $1.lastMessageSent})
                self.loadingState = .resultFound
            }
        }
    }
    
    func createChat(user: String?) async throws -> String {
        let document = try await db.collection("aichats").addDocument(data: ["lastMessageSent": Date(), "owner": user ?? ""])
        return document.documentID
    }
    
    func showProfile() {
        isShowingProfileView = true
    }
    
    func deleteChat(chat: AppChat) {
        guard let id = chat.id else { return }
        db.collection("aichats").document(id).delete()
    }
}

