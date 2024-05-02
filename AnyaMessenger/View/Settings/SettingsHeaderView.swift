//
//  SettingsHeaderView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/14/23.
//

import SwiftUI
import Kingfisher

/**
 This SettingsHeader View populates the Seetings View with the necessary user details, like name and status
 */
struct SettingsHeader: View {
    var user: User
    
    var body: some View {
        HStack(spacing: 16) {
            KFImage(URL(string: user.profileImageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(Circle())
                .padding(.leading)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.fullname)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                
                Text(user.status.description)
                    .foregroundColor(.white)
                    .font(.system(size: 14))
            }
            
            
            Spacer()
        }
        .frame(height: 80)
        .background(Color("lightGray"))
    }
}
