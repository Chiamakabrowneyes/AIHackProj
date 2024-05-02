//
//  FloatingButton.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/21/23.
//

import SwiftUI

/**
 This creates the button object that creates a segue for the user to access the the collection of users that they could potentially interact with.
 */
struct FloatingButton: View {
    @Binding var show: Bool
    
    var body: some View {
        Button(action: { show.toggle() }, label: {
            Image(systemName: "square.and.pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding()
        })
        .background(Color("darkPurple"))
        .foregroundColor(.white)
        .clipShape(Circle())
        .padding()
        
    }
}
