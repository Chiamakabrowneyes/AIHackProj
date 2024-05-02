//
//  ConversationsView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 9/30/23.
//

import SwiftUI

/**
 Conversation view contains and displays the collections of all users who are in current communication with the user in active session.
 */
struct ConversationsScene: View {
    @State var user: User?
    @State var showChat = false
    @State var isShowingNewMessageView = false
    
    //observed instance of ConversationsViewModel, responsible for managing and fetching recent messages.
    @ObservedObject var viewModel = ConversationsSceneModel()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            //Clicking on a user creates a segue for one-on-one interaction
            Color("darkGray") // Replace with the name of your desired color from your asset catalog
                            .edgesIgnoringSafeArea(.all)
            if let user = user {
                NavigationLink(destination: LazyView(ChatScene(user: user)),
                               isActive: $showChat,
                               label: {} )
            }
            
            //The ScrollView loops over viewModel.recentMessages to display each recent message.
            
            ScrollView {
                Spacer()
                    .frame(height: 10)
                VStack {
                    //Each message is rendered using a ConversationCell which takes in a MessageViewModel initialized with the current message.
                    ForEach(viewModel.recentMessages) { message in
                        if let user = message.user {
                            NavigationLink(
                                destination:
                                    LazyView(ChatScene(user: user))
                                    .onDisappear(perform: {
                                        viewModel.fetchRecentMessages()
                                    }),
                                label: {
                                    ConversationCell(viewModel: MessageSceneModel(message: message))
                                })
                        }
                    }
                }.padding()
            }
            
            HStack {
                Spacer()
                //creates FloatingButton that presents the NewMessageView starts a new chat.
                FloatingButton(show: $isShowingNewMessageView)
                    .sheet(isPresented: $isShowingNewMessageView, content: {
                        NewMessageScene(show: $isShowingNewMessageView,
                                       startChat: $showChat,
                                       user: $user)
                    })
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ConversationsView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsScene()
    }
}

