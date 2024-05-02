//
//  ProfilePhotoSelectorView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/5/23.

import SwiftUI

struct ProfilePhotoSelectView: View {
    @State private var imagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    @EnvironmentObject var viewModel: AuthSceneModel

    var body: some View {
        VStack {
            Button(action: { imagePickerPresented.toggle() }, label: {
                ZStack {
                    if let profileImage = profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 180, height: 180)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "photo.badge.plus")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFill()
                            .frame(width: 180, height: 180)
                            .clipped()
                            .padding(.top, 44)
                            .foregroundColor(.black)
                    }
                }
            })
            .sheet(isPresented: $imagePickerPresented, onDismiss: loadImage, content: {
                ImagePicker(image: $selectedImage)
            })
            .padding()
            
            Text(profileImage == nil ? "Select a profile photo" : "Great! Tap below to continue")
                .font(.system(size: 20, weight: .semibold))
            
            if let selectedImage = selectedImage {
                Button(action: { viewModel.uploadProfileImage(selectedImage) }, label: {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(Color.blue)
                        .clipShape(Capsule())
                        .padding()
                })
                .padding(.top, 24)
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}

extension ProfilePhotoSelectView {
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        profileImage = Image(uiImage: selectedImage)
    }
}


                                       

