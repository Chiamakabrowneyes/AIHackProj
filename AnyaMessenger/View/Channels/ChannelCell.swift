//
//  ChannelCell.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/21/23.
//

import SwiftUI
import Kingfisher

struct ChannelCell: View {
    let channel: Channel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                if let imageUrl = channel.imageUrl {
                    KFImage(URL(string: imageUrl))
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 56, height: 56)
                        .cornerRadius(28)
                } else {
                    Image(systemName: "person.2.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 56, height: 56)
                        .cornerRadius(28)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(channel.name)
                        .font(.system(size: 14, weight: .semibold))
                    
                    Text(channel.lastMessage)
                        .font(.system(size: 15))
                        .lineLimit(2)
                }
                .foregroundColor(.black)
                .padding(.trailing)
                
                Spacer()
            }
            
            Divider()
        }
    }
}
