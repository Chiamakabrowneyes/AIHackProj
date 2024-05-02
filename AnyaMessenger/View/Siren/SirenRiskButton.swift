//
//  SirenRiskButton.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 1/8/24.
//

import SwiftUI

struct SirenRiskButton: View {
    let title: String
    @Binding var isClicked: Bool
    let action: () -> Void // Add action as a closure

    var body: some View {
        Button(action: {
            Task {
                action()
                isClicked.toggle()
            }
        }) {
            Text(title)
                .font(.custom("chalkduster", size: 15))
                .padding(10)
                .frame(width: 100)
                .foregroundColor(isClicked ? Color.white : Color("darkPurple"))
                .bold()
                .background(isClicked ? Color("lightPink") : Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("darkPurple"), lineWidth: 2)
                )
        }
    }
}
