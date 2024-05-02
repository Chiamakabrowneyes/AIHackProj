//
//  AIChatView.swift
//  AnyaMessenger
//
//  Created by Chiamaka U on 3/2/24.
//

import SwiftUI
import Foundation

struct AIChatListView: View {
    @StateObject var aiChatListViewModel = AIChatListViewModel()
    @EnvironmentObject var authViewModel: AuthSceneModel
    @State private var selectedChatID: String?
    @State var showChat = false
    @EnvironmentObject var appState: AppState
    @State var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) { // Use NavigationStack instead of Group
            switch aiChatListViewModel.loadingState {
            case .loading, .none:
                Text("Loading chats...")
            case .noResults:
                Text("No chats.ˆ")
            case .resultFound:
                List {
                    ForEach(aiChatListViewModel.chats) { chat in
                        NavigationLink(value: chat.id) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(chat.topic ?? "New Chat")
                                        .font(.headline)
                                    Spacer()
                                    Text(chat.model?.rawValue ?? "")
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(chat.model?.tintColor ?? .white)
                                        .padding(6)
                                        .background((chat.model?.tintColor ?? .white).opacity(0.1))
                                        .clipShape(Capsule(style: .continuous))
                                }
                                Text(chat.lastMessageTimeAgo)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }.swipeActions {
                            Button(role: .destructive) {
                                aiChatListViewModel.deleteChat(chat: chat)
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                    }
                }
                .navigationDestination(for: String.self) { id in
                    AIChatView(aiChatViewModel: AIChatViewModel(chatId: id))
                }
            }
        }
        .navigationTitle("Chats")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    aiChatListViewModel.showProfile()
                } label: {
                    Image(systemName: "person")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        do {
                            let chatID = try await aiChatListViewModel.createChat(user: authViewModel.currentUser?.id)
                            appState.navigationPath.append(chatID)
                        } catch {
                            print(error)
                        }
                        
                    }
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .sheet(isPresented: $aiChatListViewModel.isShowingProfileView) {
            AIProfileView()
        }
        .onAppear {
            if aiChatListViewModel.loadingState == .none {
                aiChatListViewModel.fetchData(user: authViewModel.currentUser?.id)
            }
        }
    }
}

