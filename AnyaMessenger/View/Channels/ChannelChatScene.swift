//
//  ChannelChatView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/21/23.
//

import SwiftUI

struct ChannelChatScene: View {
    @State var messageText: String = ""
    @ObservedObject var viewModel: ChannelChatSceneModel
    @State private var selectedImage: UIImage?
    
    init(channel: Channel) {
        self.viewModel = ChannelChatSceneModel(channel: channel)
    }
    
    var body: some View {
        VStack {
            
            ScrollViewReader { value in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            ChannelMessageScene(viewModel: ChannelMessageSceneModel(message: message))
                                .id(message.id)
                        }
                    }.padding(.top)
                }
                .onReceive(viewModel.$messageToSetVisible, perform: { id in
                    value.scrollTo(id)
                })
            }
            
            CustomInputScene(inputText: $messageText,
                            selectedImage: $selectedImage,
                            action: sendMessage)
                .padding()
            
        }
        .navigationTitle(viewModel.channel.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func sendMessage() {
        viewModel.sendMessage(messageText: messageText)
        messageText = ""
    }
}
