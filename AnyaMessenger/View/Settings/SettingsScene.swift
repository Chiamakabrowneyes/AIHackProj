//
//  SettingsView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 9/30/23.
//

/**
 This Settings View Conforms to the EditProfileViewModel as its ObservableObject so any changes to that class properties will notify and update this view
 */

import SwiftUI

struct SettingsScene: View {
    @ObservedObject var viewModel: EditProfileSceneModel
    
    init(user: User) {
        self.viewModel = EditProfileSceneModel(user: user)
    }
    
    //initializing the user in the settings to populate data in the setting interface
    var body: some View {
        ZStack {
            Color("darkGray")
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                    .frame(height: 10)
                
                NavigationLink(
                    destination: EditProfileScene(viewModel: viewModel),
                    label: {
                        SettingsHeader(user: viewModel.user)
                            .padding(.vertical)
                            .background(Color("lightGray"))
                            .cornerRadius(20)
                    })
                
                VStack(spacing: 1) {
                    ForEach(SettingsCellSceneModel.allCases, id: \.self) { viewModel in
                        SettingsCell(viewModel: viewModel)
                    }
                }
                
                Button(action: { AuthSceneModel.shared.signout() }, label: {
                    Text("Log Out")
                        .foregroundColor(Color("darkPink"))
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 100, height: 50)
                        .background(Color("lightGray"))
                        .cornerRadius(20)
                })
                
                Spacer()
                
                Button(action: {
                    AuthSceneModel.shared.deleteAccount { error in
                        if let error = error {
                            // Handle error, e.g., display an alert or show an error message
                            print("Failed to delete account with error: \(error.localizedDescription)")
                        } else {
                            // Account deleted successfully
                            // You can perform any additional actions here, e.g., navigate to a different view or display a success message
                            print("Account deleted successfully")
                        }
                    }
                }, label: {
                    Text("Delete Account")
                        .foregroundColor(Color("darkPink"))
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 150, height: 50)
                        .background(Color("lightGray"))
                        .cornerRadius(20)
                })

                Spacer()
            }
        }
    }
}

struct RoundedBottomCornersShape: Shape {
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius), radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius), radius: radius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        path.closeSubpath()
        return path
    }
}
