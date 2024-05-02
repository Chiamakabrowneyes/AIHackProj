//
//  NavigationBar.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 1/10/24.
//

import SwiftUI

struct NavigationBar: View {
    @Binding var searchText: String
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthSceneModel
    
    
    var body: some View {
        if let user = viewModel.currentUser {
            VStack(spacing: 8) {
                
                Spacer()
                    .frame(height: 75)
                
                // MARK: Search Bar
                HStack(spacing: 2) {
                    Image(systemName: "magnifyingglass")
                    
                    TextField("Search for a city or airport", text: $searchText)
                        .foregroundColor(Color("darkPink"))
                }
                .foregroundColor(Color("darkPink"))
                .padding(.horizontal, 6)
                .padding(.vertical, 7)
                .frame(height: 36, alignment: .leading)
                .background(Color.bottomSheetBackground, in: RoundedRectangle(cornerRadius: 10))
                .innerShadow(shape: RoundedRectangle(cornerRadius: 10), color: .black.opacity(0.25), lineWidth: 2, offsetX: 0, offsetY: 2, blur: 2)
            }
            .frame(height: 126, alignment: .top)
            .padding(.horizontal, 16)
            .padding(.top, 49)
            .backgroundBlur(radius: 20, opaque: true)
            .background(Color("lightGray"))
            .frame(maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea()
        }
    }
}
