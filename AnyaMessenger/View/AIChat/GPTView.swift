//
//  GPTView.swift
//  AnyaMessenger
//
//  Created by Chiamaka U on 3/3/24.
//

import SwiftUI



struct GPTView: View {
    @ObservedObject var appState: AppState = AppState()
    var body: some View {
        Group {
            NavigationStack(path: $appState.navigationPath){
                AIChatListView()
                    .environmentObject(appState)
            }
        }
    }
}

#Preview {
    GPTView()
}
