//
//  ChannelsMessageView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/21/23.
//

import SwiftUI
import Kingfisher

struct ChannelMessageScene: View {
    let viewModel: ChannelMessageSceneModel
    
    var body: some View {
        HStack {
            if viewModel.isFromCurrentUser {
                Spacer()
                
                Text(viewModel.message.text)
                    .padding(12)
                    .background(Color.blue)
                    .clipShape(ChatBubble(isFromCurrentUser: true))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.leading, 100)
                    .font(.system(size: 15))
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.fullname)
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                        .padding(.leading, 44)
                    
                    HStack(alignment: .bottom) {
                        KFImage(URL(string: viewModel.message.user?.profileImageUrl ?? ""))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                        
                        Text(viewModel.message.text)
                            .padding(12)
                            .background(Color(.systemGray5))
                            .font(.system(size: 15))
                            .clipShape(ChatBubble(isFromCurrentUser: false))
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, 8)
                .padding(.horizontal)
                .padding(.trailing, 80)
                
                Spacer()
            }
        }
    }
}
