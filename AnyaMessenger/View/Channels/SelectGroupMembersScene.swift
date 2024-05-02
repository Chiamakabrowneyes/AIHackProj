//
//  SelectGroupMembersView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/21/23.
//

import SwiftUI
import Kingfisher

struct SelectGroupMembersScene: View {
    @State var searchText = ""
    @Binding var show: Bool
    @Binding var startChat: Bool
    @Binding var users: [SelectableUser]
    @ObservedObject var viewModel = NewMessageSceneModel(config: .group)
    
    var body: some View {
        NavigationView {
            VStack {
                
                SearchBar(text: $searchText, isEditing: .constant(false))
                    .padding()
                
                if !viewModel.selectedUsers.isEmpty {
                    GroupMembersScene(viewModel: viewModel)
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.selectableUsers) { user in
                            HStack { Spacer() }
                            
                            Button(action: {
                                viewModel.selectUser(user, isSelected: !user.isSelected)
                            }, label: {
                                SelectableUserCell(selectableUser: user)
                            })
                        }
                    }.padding(.leading)
                }
            }
            .navigationBarItems(leading: cancelButton, trailing: nextButton)
            .navigationTitle("New Group")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var nextButton: some View {
        NavigationLink(destination: CreateChannelScene(users: viewModel.selectedUsers.map({ $0.user }), show: $show)) {
            Text("Next").bold()
        }
    }
    
    var cancelButton: some View {
        Button { show.toggle() } label: {
            Text("Cancel")
        }
    }
}
