//
//  GroupMembersView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/21/23.
//

import SwiftUI
import Kingfisher

struct GroupMembersScene: View {
    @ObservedObject var viewModel: NewMessageSceneModel
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .top, spacing: 8) {
                ForEach(viewModel.selectedUsers) { user in
                    ZStack(alignment: .topTrailing) {
                        VStack {
                            KFImage(URL(string: user.user.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipped()
                                .cornerRadius(60 / 2)
                                .shadow(color: .gray, radius: 4, x: 0, y: 2)
                            
                            Text(user.user.fullname)
                                .font(.system(size: 11, weight: .semibold))
                                .multilineTextAlignment(.center)
                        }.frame(width: 64)
                        
                        Button(action: { viewModel.selectUser(user, isSelected: false) }, label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10)
                                .padding(6)
                        })
                        .background(Color(.gray))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                    }
                }
            }
        }
        .animation(.spring())
        .padding()
    }
}

