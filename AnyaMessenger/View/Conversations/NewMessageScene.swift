//
//  NewMessageView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/1/23.
//

import SwiftUI
/**
This class handles the starting of a new message or chat conversation.
It provides a search bar to filter users and allows the user to select someone to initiate a chat with.
 */
struct NewMessageScene: View {
    @State var searchText = ""
    @State var isEditing = false
    @Binding var show: Bool
    @Binding var startChat: Bool
    @Binding var user: User?
    @State private var sirenListId: String?
    @ObservedObject var viewModel = NewMessageSceneModel(config: .chat)


    var body: some View {
        ScrollView {
            // Displays a SearchBar with a bindable text and isEditing state.
            // An .onTapGesture is added to toggle the isEditing state when the search bar is tapped.
            SearchBar(text: $searchText, isEditing: $isEditing)
                .onTapGesture {isEditing.toggle() }
                .padding()


            VStack(alignment: .leading) {
                ForEach(searchText.isEmpty ? viewModel.users : viewModel.filteredUsers(searchText)) { user in
                    HStack { Spacer() }

                    Button(action: {
                        self.show.toggle()
                        self.startChat.toggle()
                        self.user = user
                        
                        viewModel.addUserToSirenList(userToAddId: user.id ?? "unknown") { success in
                            if success {
                                print("User successfully added to siren list.")
                            }
                            else {
                                print("Failed to add user to siren list.")
                            }
                        }
                    }, label: {
                        UserCell(user: user)
                    })
                }
            }.padding(.leading)
        }
    }
    
}
