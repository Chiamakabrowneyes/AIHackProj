//
//  ChatBubble.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/1/23.
//

import SwiftUI

/**
 The chatBubble struct creates a unique shape for the message cell depending on whether the current user is the sender or reciever of the text
 */
struct ChatBubble: Shape {
    var isFromCurrentUser: Bool

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, isFromCurrentUser ? .bottomLeft: .bottomRight], cornerRadii: CGSize(width: 16, height: 16))
        
        return Path(path.cgPath)
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubble(isFromCurrentUser: false)
    }
}
