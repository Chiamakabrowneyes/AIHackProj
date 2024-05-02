//
//  ChannelsView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 9/30/23.
//

import SwiftUI

struct ChannelsScene: View {
    @State var showNewGroupView = false
    @State var showChat = false
    @State var users = [SelectableUser]()
    @ObservedObject var viewModel = ChannelsSceneModel()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            if !users.isEmpty {
                NavigationLink(destination: Text("Group chat"),
                               isActive: $showChat,
                               label: {} )
            }
            
            ScrollView {
                VStack {
                    ForEach(viewModel.channels) { channel in
                        NavigationLink(
                            destination:
                                LazyView(ChannelChatScene(channel: channel))
                                .onDisappear(perform: {
                                    viewModel.fetchChannels()
                                }),
                            label: {
                                ChannelCell(channel: channel)
                            })
                    }
                }.padding()
            }
            
            HStack {
                Spacer()
                
                FloatingButton(show: $showNewGroupView)
                    .sheet(isPresented: $showNewGroupView, content: {
                        SelectGroupMembersScene(show: $showNewGroupView,
                                               startChat: $showChat,
                                               users: $users)
                    })
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ChannelsView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelsScene()
    }
}
