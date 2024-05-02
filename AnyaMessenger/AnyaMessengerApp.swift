//
//  AnyaMessenger.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/25/23.
//

import SwiftUI
import Firebase

//@main
struct AnyaMessengerApp: App {

    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AuthSceneModel.shared)
        }
    }
}
