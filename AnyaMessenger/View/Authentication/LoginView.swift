import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthSceneModel
    
    var body: some View {
        NavigationView {
            ZStack {   // Add this ZStack
                Image("bg_anya")
                    .resizable()
                    .aspectRatio(contentMode: .fill)  // makes sure the image fills the entire screen
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    VStack{
                        Text("Anya")
                            .font(.custom("chalkduster", size: 25))
                        
                        VStack(spacing: 20) {
                            LoginDetailView(placeholder: "Email", detail: $email)
                            LoginDetailView(placeholder: "Password", detail: $password)
                        }
                        
                        
                        Button(action: {
                            viewModel.login(withEmail: email, password: password)
                        }, label: {
                            Text("Log In")
                                .font(.custom("chalkduster", size: 15))
                                .padding(10)
                                .border(Color.gray, width: 1)
                                .foregroundColor(Color("darkPurple"))
                                .bold()
                                .tint(.black)
                        })
                        .shadow(color: .gray, radius: 10, x: 0.0, y: 0.0)
                        
                        NavigationLink(
                            destination: SignupView().navigationBarBackButtonHidden(true),
                            label: {
                                HStack {
                                    Text("Don't have an account?")
                                        .font(.custom("chalkduster", size: 12))
                                        .shadow(color: .gray, radius: 10)
                                        .foregroundColor(.gray)
                                    
                                    Text("Sign Up")
                                        .font(.custom("chalkduster", size: 12))
                                        .shadow(color: .gray, radius: 12)
                                        .foregroundColor(Color("darkPurple"))
                                }
                                
                            }).padding(16)
                        
                        HStack {
                            NavigationLink(
                                destination: Text("Reset Password.."),
                                label: {
                                    Text("Forgot Password?")
                                        .font(.custom("chalkduster", size: 12))
                                        .foregroundColor(Color("darkPurple"))
                                })
                        }
                    }
                    .padding(.top, -56)   // moved this padding to affect the entire VStack
                }
            }
        }
    }
    
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView()
        }
    }
    
    struct LoginDetailView: View {
           
           let placeholder: String
           let detail: Binding<String>
           
           var body: some View {
               TextField(placeholder, text: detail).textInputAutocapitalization(.never).backgroundStyle(.blue.gradient)
                   .padding(10)
                   .border(Color.gray, width: 1)
                   .font(.custom("chalkduster", size: 15))
                   .multilineTextAlignment(.center)
                   .shadow(color: .gray, radius: 10)
                   .frame(width: 300)
           }
       }
   }
