//
//  StatusSelectorView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 9/30/23.
//

import SwiftUI

/**
 This SelectStatus View allows user to interact with the view and change their status cell.
 */
struct SelectStatusScene: View {
    @ObservedObject var viewModel: EditProfileSceneModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color(.systemGroupedBackground)
            
            
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Text("CURRENTLY SET TO")
                        .foregroundColor(.gray)
                        .padding()
                    
                    StatusCell(status: viewModel.user.status)
                    
                    Text("SELECT YOUR STATUS")
                        .foregroundColor(.gray)
                        .padding()
                    
                    ForEach(UserStatus.allCases.filter({ $0 != .notConfigured }), id: \.self) { status in
                        Button(action: { viewModel.updateUserStatus(status) }, label: {
                            StatusCell(status: status)
                        })
                    }
                }
            }
        }
    }
}

struct StatusCell: View {
    let status: UserStatus
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(status.description)
                    .foregroundColor(.black)
                Spacer()
            }.padding(.horizontal)

        }
        .frame(height: 56)
        .background(Color.white)
    }
}
