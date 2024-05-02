//
//  SettingsCell.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 9/30/23.
//

import SwiftUI

//This SettingsCell Class creates the UI properties in the settings view
struct SettingsCell: View {
    let viewModel: SettingsCellSceneModel
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(systemName: viewModel.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(6)
                    .foregroundColor(Color("darkPink"))
                    .cornerRadius(6)

                Text(viewModel.title)
                    .font(.system(size: 15))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                
            }
            .padding(.top)
            .padding(.horizontal)
            
            Divider()
                .padding(.leading)
        }
        .frame(height: 56)
        .background(Color("lightGray"))
        .cornerRadius(20)
    }
}

struct SettingsCell_Previews: PreviewProvider {
    static var previews: some View {
        SettingsCell(viewModel: SettingsCellSceneModel(rawValue: 2)!)
    }
}
