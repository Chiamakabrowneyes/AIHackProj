//  AIChatViewModel.swift
//  AnyaMessenger
//
//  Created by Chiamaka U on 3/3/24.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import SwiftUI
import GoogleGenerativeAI  // Import the Google Generative AI SDK

class AIChatViewModel: ObservableObject {
    @Published var chat: AppChat?
    @Published var messages: [AppMessage] = []
    @Published var messageText: String = ""
    @Published var selectedModel: AIChatModel = .gpt3_5_turbo
    let chatId: String

    let db = Firestore.firestore()
    private var chatSession: Chat?
    
    init(chatId: String) {
        self.chatId = chatId
        self.startChatSession()
    }

    func fetchData() {
        db.collection("chats").document(chatId).getDocument(as: AppChat.self) { result in
            switch result {
                
            case .success(let success):
                DispatchQueue.main.async {
                    self.chat = success
                }
                
            case .failure(let failure):
                print(failure)
            }
            
        }
        
        db.collection("aichats").document(chatId).collection("aimessages").getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents, !documents.isEmpty else { return }
            
            self.messages = documents.compactMap({ snapshot -> AppMessage? in
                do {
                    var message = try snapshot.data(as: AppMessage.self)
                    message.id = snapshot.documentID
                    return message
                } catch {
                    return nil
                }
            })
        }
    }
    
    
    private func startChatSession() {
        if chatSession == nil {
            let history = messages.compactMap { try? ModelContent(role: $0.role.rawValue, parts: [$0.text]) }
            chatSession = GenerativeModel(name: "gemini-pro", apiKey: GEMINI_API_KEY).startChat(history: history)
        }
    }
    
    
    func sendMessage() async throws {
        
        var newMessage = AppMessage(id: UUID().uuidString, text: messageText , role: .user)
        
        do {
            let documentRef = try storeMessage(message: newMessage)
            newMessage.id = documentRef.documentID
        } catch {
            print(error)
        }
        
        if messages.isEmpty {
            setupNewChat()
        }
        
        await MainActor.run { [newMessage] in
            messages.append(newMessage)
        }
        
        
        var preText = "In 50 words: " + messageText + ". Please don't use asterisks"
        var reqMessage = AppMessage(id: UUID().uuidString, text: preText, role: .user)
        
        messageText = ""
        try await generateResponse(for: reqMessage)
       
        
    }
    
    
    
    private func storeMessage(message: AppMessage) throws -> DocumentReference {
        return try db.collection("aichats").document(chatId).collection("aimessages").addDocument(from: message)
    }
    
    
    private func setupNewChat() {
        db.collection("aichats").document(chatId).updateData(["model": selectedModel.rawValue])
        DispatchQueue.main.async { [weak self] in
            self?.chat?.model = self?.selectedModel
        }
    }
    
    private func generateResponse(for message: AppMessage) async throws {
        guard let chatSession = self.chatSession else {
            startChatSession()
            return
        }
        
        do {
            let response = try await chatSession.sendMessage(message.text)
            guard let newText = response.text else { return }
            await MainActor.run {
                let newMessage = AppMessage(id: UUID().uuidString, text: newText, role: .assistant)
                messages.append(newMessage)
            }
            if let lastMessage = messages.last {
                _ = try storeMessage(message: lastMessage)
            }
        } catch {
            print("Failed to generate response: \(error)")
        }
    }
}


enum ChatRole: String, Codable, Hashable {
    case user
    case assistant
}

// Make sure AppMessage conforms to Codable and Hashable

struct AppMessage: Identifiable, Codable, Hashable {
    var id: String?
    var text: String
    let role: ChatRole
}

extension AppMessage: Equatable {
    static func == (lhs: AppMessage, rhs: AppMessage) -> Bool {
        return lhs.id == rhs.id
    }
}

