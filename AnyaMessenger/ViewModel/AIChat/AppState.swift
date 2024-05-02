//
//  AppState.swift
//  AnyaMessenger
//
//  Created by Chiamaka U on 3/3/24.
//

import Foundation
import FirebaseAuth
import SwiftUI
import Firebase

class AppState: ObservableObject {
    @EnvironmentObject var authViewModel: AuthSceneModel
    @Published var currentUser: User?
    @Published var navigationPath = NavigationPath()
}
