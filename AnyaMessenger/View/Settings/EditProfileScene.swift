//
//  EditProfileView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 9/30/23.
//

import SwiftUI
import Kingfisher

/**
 This EditProfileView class handles the intergrated functionality and UI adaptations for changes that gets reflected in the settings view
 */
struct EditProfileScene: View {
    @ObservedObject var viewModel: EditProfileSceneModel
    @State private var fullname: String
    @State private var inEditMode = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    
    var nameChanged: Bool { return viewModel.user.fullname != fullname }
    
    init(viewModel: EditProfileSceneModel) {
        self.viewModel = viewModel
        self._fullname = State(initialValue: viewModel.user.fullname)
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                VStack {
                    HStack(alignment: .center) {
                        VStack(alignment: .center) {
                            if let profileImage = profileImage {
                                profileImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 64, height: 64)
                                    .clipShape(Circle())
                            } else {
                                //calls method to change user profile imagae
                                KFImage(URL(string: viewModel.user.profileImageUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 64, height: 64)
                                    .clipShape(Circle())
                            }
                            
                            Button(action: { showImagePicker.toggle() }, label: {
                                Text("Edit")
                                    .padding(.leading, 2)
                            }).sheet(isPresented: $showImagePicker, onDismiss: loadImage, content: {
                                ImagePicker(image: $selectedImage)
                            })
                        }
                        .padding(.top)
                        
                        Text("Enter your name or change your profile photo")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .padding([.bottom, .horizontal])
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .background(Color.white)
                    
                    Divider().padding(.horizontal)
                    
                    TextField("", text: $fullname) { _ in
                        self.inEditMode = true
                    }
                    .padding(8)
                    .background(Color.white)
                    
                    Divider().padding(.horizontal)
                }
                .background(Color.white)
                                
                VStack(alignment: .leading) {
                    Text("Status")
                        .padding()
                        .foregroundColor(.gray)
                    
                    //calls method to change status and updates user description
                    NavigationLink(
                        destination: SelectStatusScene(viewModel: viewModel),
                        label: {
                            HStack(alignment: .center) {
                                Text(viewModel.user.status.description)
                                    .frame(height: 50)
                                    .padding(.leading)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    .padding(.trailing)
                            }
                            .background(Color.white)
                        })
                }
                .padding(.top, 44)
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Edit Profile")
        .navigationBarItems(leading: inEditMode ? cancelButton : nil,
                            trailing: inEditMode || selectedImage != nil ? doneButton : nil)
        .navigationBarBackButtonHidden(inEditMode)
    }
    
    var doneButton: some View {
        Button(action: {
            UIApplication.shared.endEditing()
            inEditMode = false
            
            if nameChanged {
                viewModel.updateName(fullname)
            }
            
            if let selectedImage = selectedImage {
                viewModel.updateProfileImage(selectedImage)
            }
            
        }, label: {
            Text("Done")
                .bold()
        })
    }
    
    var cancelButton: some View {
        Button(action: { UIApplication.shared.endEditing() }, label: {
            Text("Cancel")
        })
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        profileImage = Image(uiImage: selectedImage)
    }
}
