//
//  CreateChannelView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/21/23.
//

import SwiftUI

struct CreateChannelScene: View {
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var channelImage: Image?
    @State private var channelName = ""
    @Binding var show: Bool

    @ObservedObject var viewModel: CreateChannelSceneModel
    
    init(users: [User], show: Binding<Bool>) {
        self.viewModel = CreateChannelSceneModel(users: users)
        self._show = show
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 32) {
                Button(action: { showImagePicker.toggle() }, label: {
                    if let channelImage = channelImage {
                        channelImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                    } else {
                        Image("plus_photo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                    }
                }).sheet(isPresented: $showImagePicker, onDismiss: loadImage, content: {
                    ImagePicker(image: $selectedImage)
                })
                
                VStack(alignment: .leading, spacing: 12) {
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(Color(.separator))
                    
                    TextField("Enter a name for your channel..", text: $channelName)
                        .font(.system(size: 15))
                    
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(Color(.separator))
                    
                    Text("Please provide a channel name and icon")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }.padding(.trailing)
                
            }.padding()
            
            Spacer()
        }
        .onReceive(viewModel.$didCrateChannel, perform: { completed in
            if completed {
                show.toggle()
            }
        })
        .navigationBarItems(trailing: createChannelButton)
    }
    
    var createChannelButton: some View {
        Button(action: { viewModel.createChannel(name: channelName, image: selectedImage)}, label: {
            Text("Create").bold()
                .disabled(channelName.isEmpty && channelImage != nil)
        })
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        channelImage = Image(uiImage: selectedImage)
    }
}


