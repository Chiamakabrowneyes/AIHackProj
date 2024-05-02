//
//  CustomTextField.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/21/23.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: Text
    let imageName: String
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    placeholder
                        .foregroundColor(Color(.placeholderText))
                        .padding(.leading, 40)
                }
                
                HStack {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(.darkGray))
                    
                    TextField("", text: $text)
                        .textFieldStyle(PlainTextFieldStyle())
                }
            }
            
            Divider()
                .background(Color(.black))
        }
    }
}
