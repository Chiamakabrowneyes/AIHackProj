//
//  SignupView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 9/30/23.
//

import SwiftUI

struct SignupView: View {
    @State var fullName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var username: String = ""
    
    @EnvironmentObject var viewModel: AuthSceneModel
    

    
    var body: some View {
        ZStack {
            Image("bg_anya")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            NavigationLink(
                destination: ProfilePhotoSelectView(),
                isActive: $viewModel.didRegister,
                label: {
            })
            
            VStack{
                Text("Anya")
                    .font(.custom("chalkduster", size: 25))
                SignupDetailView(imageName: "person", placeholder: "Full Name", detail: $fullName)
                SignupDetailView(imageName: "envelope", placeholder: "Email", detail: $email)
                    .textContentType(.emailAddress)
                SignupDetailView(imageName: "key", placeholder: "Username", detail: $username)
                SignupDetailView(imageName: "lock", placeholder: "Password", detail: $password)
                    .textContentType(.password)
                
                
                Button(action: {
                    viewModel.register(withEmail: email,
                                       password: password,
                                       fullname: fullName,
                                       username: username)
                },  label: {
                    Text("Sign Up")
                        .font(.custom("chalkduster", size: 15))
                        .padding(10)
                        .border(Color.gray, width: 1)
                        .foregroundColor(Color("darkPurple"))
                        .bold()
                        .tint(.black)
                    
                })
                
                NavigationLink(
                    destination: LoginView().navigationBarBackButtonHidden(true),
                    label: {
                        HStack {
                            Text("Already Have account? ")
                                .font(.custom("chalkduster", size: 12))
                                .shadow(color: .gray, radius: 10)
                                .foregroundColor(.gray)
                            
                            Text("Log In")
                                .font(.custom("chalkduster", size: 12))
                                .shadow(color: .gray, radius: 12)
                                .foregroundColor(Color("darkPurple"))
                        }
                        
                    }).padding(16)
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

struct SignupDetailView: View {
    let imageName: String
    let placeholder: String
    let detail: Binding<String>
    
    var body: some View {
        HStack{
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
                .padding(10)
            
            
            TextField(placeholder, text: detail).textInputAutocapitalization(.never).backgroundStyle(.blue.gradient)
                .padding(10)
                
                .font(.custom("chalkduster", size: 15))
                .multilineTextAlignment(.leading)
                .shadow(color: .gray, radius: 10)
                .frame(width: 270)
        }.border(Color.gray, width: 1)
        }
}
