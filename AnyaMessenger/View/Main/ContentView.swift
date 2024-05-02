//
//  ContentView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 9/30/23.
//


    
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthSceneModel
    //Determining the display interface when the app is launch depending on whether the user is logged in
    
    var body: some View {
        Group {
            if $viewModel.userSession != nil {
                MainTabScene()
            } else {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
