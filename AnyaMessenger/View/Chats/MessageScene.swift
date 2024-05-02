//
//  MessageView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/1/23.
//

import SwiftUI
import Kingfisher

/**
 The MessageView struct represents an individual message within the chat.
 It's designed to accommodate different types of messages (text or image) and distinguish between messages sent by the current user and those received from another user.
 */
struct MessageScene: View {
    let viewModel: MessageSceneModel
    
    
    var body: some View {
        HStack {
            if viewModel.isFromCurrentUser {
                Spacer()
                
                if viewModel.isImageMessage {
                    KFImage(viewModel.messageImageUrl)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(maxWidth: UIScreen.main.bounds.width / 1.5, maxHeight: 800)
                        .cornerRadius(10)
                        .padding(.trailing)
                } else {
                    Text(viewModel.message.text)
                        .padding(12)
                        .background(Color("darkPurple"))
                        .clipShape(ChatBubble(isFromCurrentUser: true))
                        .foregroundColor(Color("darkGray"))
                        .padding(.horizontal)
                        .padding(.leading, 100)
                        .font(.system(size: 15))
                }
            } else {
                HStack(alignment: .bottom) {
                    
                    KFImage(viewModel.profileImageUrl)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                    
                    if viewModel.isImageMessage {
                        KFImage(viewModel.messageImageUrl)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(maxWidth: UIScreen.main.bounds.width / 1.5, maxHeight: 800)
                            .cornerRadius(10)
                    } else {
                        Text(viewModel.message.text)
                            .padding(12)
                            .background(Color("darkPink"))
                            .font(.system(size: 15))
                            .clipShape(ChatBubble(isFromCurrentUser: false))
                            .foregroundColor(.black)
                    }
                    
                }
                .padding(.horizontal)
                .padding(.trailing, 80)
                
                
                Spacer()
            }
        }
    }
}
