//
//  AIChatView.swift
//  AnyaMessenger
//
//  Created by Chiamaka U on 3/3/24.
//

import SwiftUI


struct AIChatView: View {
    @StateObject var aiChatViewModel: AIChatViewModel
    
    var body: some View {
        VStack {
            chatSelection
            ScrollViewReader { scrollView in
                List(aiChatViewModel.messages) { message in
                    messageView(for: message)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .id(message.id)
                        .onChange(of: aiChatViewModel.messages) { newValue in
                            scrollToBottom(scrollView: scrollView)
                        }
                }
                .listStyle(.plain)
                
                
            }
            messageInputView
        }
        .navigationTitle(aiChatViewModel.chat?.topic ?? "New Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            aiChatViewModel.fetchData()
        }
        .background(Color("darkGray"))
    }
    
    func scrollToBottom(scrollView: ScrollViewProxy) {
        guard !aiChatViewModel.messages.isEmpty, let lastMessage = aiChatViewModel.messages.last else { return }
        
        withAnimation {
            scrollView.scrollTo(lastMessage.id)
        }
    }
    
    var chatSelection: some View {
        Group {
            if let model = aiChatViewModel.chat?.model?.rawValue {
                Text(model)
            } else {
                Picker(selection: $aiChatViewModel.selectedModel) {
                    ForEach(AIChatModel.allCases, id: \.self) { model in
                        Text(model.rawValue)
                    }
                } label: {
                    Text("")
                }
                .pickerStyle(.segmented)
                .padding()

            }
        }
    }
    
    func messageView(for message: AppMessage) -> some View {
        HStack {
            if (message.role == .user) {
                Spacer()
            }
            Text(message.text)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .foregroundStyle(message.role == .user ? .black: .black)
                .background(message.role == .user ? Color("darkPink") : Color("darkPurple"))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            if (message.role == .assistant) {
                Spacer()
            }
        }
        
    }
    
    var messageInputView: some View {
        HStack {
            TextField("Send a message...", text: $aiChatViewModel.messageText)
                .padding()
                .foregroundColor(.black) // This changes the text color to white
                .background(Color(.white))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onSubmit {
                    sendMessage()
                }
            Button {
                sendMessage()
            } label: {
                Text("Send")
                    .padding()
                    .foregroundColor(.white) // Ensures the button label text is also white
                    .bold()
                    .background(Color("darkPink"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
    }

    
    
    func sendMessage() {
        Task {
            do {
                try await aiChatViewModel.sendMessage()
                
            } catch {
                print(error)
            }
        }
    }
}

