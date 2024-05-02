//
//  SelectableUserCell.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/21/23.
//

import SwiftUI
import Kingfisher

struct SelectableUserCell: View {
    let selectableUser: SelectableUser
        
    var body: some View {
        HStack {
            KFImage(URL(string: selectableUser.user.profileImageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(selectableUser.user.username)
                    .font(.system(size: 14, weight: .semibold))
                
                Text(selectableUser.user.fullname)
                    .font(.system(size: 14))
            }.foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: selectableUser.isSelected ? "checkmark.circle.fill" : "circle")
                .resizable()
                .scaledToFit()
                .foregroundColor(selectableUser.isSelected ? .blue : .gray)
                .frame(width: 20, height: 20)
                .padding(.trailing)
        }
    }
}
