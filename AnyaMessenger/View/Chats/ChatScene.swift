import SwiftUI

struct ChatScene: View {
    let user: User
    @ObservedObject var viewModel: ChatSceneModel
    @State private var messageText: String = ""
    @State private var selectedImage: UIImage?
    
    init(user: User) {
        self.user = user
        self.viewModel = ChatSceneModel(user: user)
    }
    
    var body: some View {
        VStack {
            
            ScrollViewReader { value in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageScene(viewModel: MessageSceneModel(message: message))
                                .id(message.id)
                        }
                    }
                    .padding(.top)
                }
                .onReceive(viewModel.$messageToSetVisible, perform: { id in
                    print("Received messageToSetVisible update with id: \(id ?? "nil")")
                    value.scrollTo(id)
                })
            }
                        
            CustomInputScene(inputText: $messageText,
                            selectedImage: $selectedImage,
                            action: sendMessage)
                .padding()
        }
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func sendMessage() {
        if let image = selectedImage {
            viewModel.send(type: .image(image))
            selectedImage = nil
        } else {
            viewModel.send(type: .text(messageText))
            messageText = ""
        }
    }
}
