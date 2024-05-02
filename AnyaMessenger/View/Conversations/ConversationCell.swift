//
//  UserCell.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/1/23.
//

import SwiftUI
import Kingfisher

/**
 Creates the display object for a user that has an ongoing conversation with the active user
 */
struct ConversationCell: View {
    let viewModel: MessageSceneModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                KFImage(viewModel.profileImageUrl)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 56, height: 56)
                    .cornerRadius(28)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.fullname)
                        .font(.system(size: 14, weight: .semibold))
                    
                    Text(viewModel.message.text)
                        .font(.system(size: 15))
                        .lineLimit(2)
                }
                .foregroundColor(.white)
                .padding(12)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 1)
                )
                
                Spacer()
            }
            
            Divider()
        }
    }
}
