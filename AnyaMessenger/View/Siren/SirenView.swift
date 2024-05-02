//
//  SirenView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 11/4/23.
//

import SwiftUI

struct SirenView: View {
    let user: User
    @ObservedObject var viewModel: SirenViewModel
    @ObservedObject var alertViewModel: AlertViewModel
    @State var speed: Double = 50
    @State var isEditing = false
    @State var messageText: String = ""
    @State private var selectedImage: UIImage?
    @State private var isButtonClicked: [Bool] = Array(repeating: false, count: 6)
    @State private var selectedRisk: [String] = Array()
    

    
    let riskTypes = [
                ("Robbery", "Robbery"),
                ("Burglary", "Burglary"),
                ("S. Assault", "S. Assault"),
                ("Kidnap", "Kidnap"),
                ("Lost", "Lost"),
                ("Sickness", "Sickness")
            ]
            

    //initializes the required parameters for Chat view
    init(user: User) {
        self.user = user
        self.viewModel = SirenViewModel(user: user)
        self.alertViewModel = AlertViewModel()
    }
    
    var body: some View {
        
        var riskDescription: String {
                switch Int(speed) {
                case ..<20:
                    return "Very minimal risk level"
                case 20..<40:
                    return "Minimal risk level"
                case 40..<60:
                    return "Average risk level"
                case 60..<80:
                    return "Beyond average risk level"
                case 80..<90:
                    return "Dangerous risk level"
                default:
                    return "Very Dangerous risk level"
                }
            }
        
        VStack {
            Spacer()
            Text("Send Siren Call")
                .foregroundColor(Color("darkPink"))
                .font(.custom("chalkduster", size: 20))
                .padding(20)
            
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12),
                        ],
                        spacing: 12
                    ) {
                        ForEach(0..<riskTypes.count, id: \.self) { index in
                            SirenRiskButton(
                                title: riskTypes[index].0,
                                isClicked: $isButtonClicked[index]
                            ) {
                                viewModel.addRiskTypes(riskType: riskTypes[index].1)
                            }
                        }
                    }
                    .padding(12) // Add horizontal padding
                    .frame(width: geometry.size.width, alignment: .leading)
                }
            }
            .frame(height: 150)
            .padding(.bottom, 10)
            
            
            Text("\(Int(speed))")
                .foregroundColor(Color("darkPurple"))
                .font(.custom("chalkduster", size: 15))
            
            Slider(
                value: $speed,
                in: 0...100,
                step: 2
            )
            {
                Text("Speed")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("100")
            } onEditingChanged: { editing in
                isEditing = editing
            }
            .frame(width: 300)
            .foregroundColor(Color("darkPurple"))
            .accentColor(Color("darkPink"))
            .font(.custom("chalkduster", size: 15))
            
            
            Text(riskDescription)
                .foregroundColor(Color("darkPurple"))
                .font(.custom("chalkduster", size: 15))
                
                
            Spacer()
                .frame(height: 50)
            
            Button(action: {
                            Task {
                                viewModel.sendMessageToSirenList(riskDescription: riskDescription)
                                resetButtons()
                                createUserActivity()
                            }
                        }) {
                            HStack {
                                Image(systemName: "bell.and.waves.left.and.right.fill")
                            }
                            .font(.custom("chalkduster", size: 25))
                            .padding(5)
                            .cornerRadius(20)
                            .foregroundColor(Color("darkPink"))
                        }
           
            Spacer(minLength: 100)
            
        }
        .background(Color("darkGray")) // Change "YourBackgroundColor" to the color you want
        .edgesIgnoringSafeArea(.all)
        .tabViewStyle(DefaultTabViewStyle())
    }
    
    
    
    
    
    
    
    func automateSiren() {
        var riskDescription = "\nThis trigger is sent with Siri"
        viewModel.sendMessageToSirenList(riskDescription: riskDescription)
        resetButtons()
        createUserActivity()
    }
    
    func resetButtons() {
        isButtonClicked = Array(repeating: false, count: isButtonClicked.count)
    }
    
    func createUserActivity(){
        let activityType = "com.chiamakabrowneyes.Anya.automateSiren"
        let activity = NSUserActivity(activityType: activityType)
        activity.title = "Siren Call Trigger"
        
        activity.isEligibleForHandoff = true
        activity.isEligibleForSearch = true
        activity.isEligibleForPublicIndexing = true
        
        activity.becomeCurrent()
        print("activity created")
    }
}




