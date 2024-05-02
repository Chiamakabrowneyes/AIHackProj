import SwiftUI

struct MainTabScene: View {
    @State private var selectedIndex = 0
    @EnvironmentObject var viewModel: AuthSceneModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationView {
                TabView(selection: $selectedIndex) {
                    SirenView(user: user)
                        .tabItem {
                            Image(systemName: "cube")
                            Text("Siren")
                        }
                        .tag(0)
                    ConversationsScene()
                        .tabItem {
                            Image(systemName: "bubble.left")
                            Text("Chats")
                        }
                        .tag(1)
                    
                    ObserveScene(user: user)
                        .tabItem {
                            Image(systemName: "eyes.inverse")
                            Text("Observe")
                        }
                        .tag(2)
                    GPTView()
                        .tabItem {
                            Image(systemName: "brain")
                            Text("AI Chat")
                        }
                        .tag(3)
                    
                    SettingsScene(user: user)
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                        .tag(4)
                }
                .navigationTitle(tabTitle)
                .navigationBarTitleDisplayMode(.inline)
                .foregroundColor(Color("darkGray"))
                .accentColor(Color("darkPink"))
                
            }
        } else {
            LoginView()
        }
    }
    
    var tabTitle: String {
        switch selectedIndex {
        case 0: return "Siren"
        case 1: return "Chats"
        case 2: return "Observe"
        case 3: return "AI Chat"
        case 4: return "Settings"
        default: return ""
        }
    }
}
