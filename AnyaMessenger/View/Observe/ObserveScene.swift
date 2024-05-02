//
//  ObserveScene.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 1/9/24.
//

import SwiftUI
import BottomSheet


enum BottomSheetPosition: CGFloat, CaseIterable {
    case top = 0.83 // 702/844
    case middle = 0.385 // 325/844
}

struct ObserveScene: View {
    let user: User
    @ObservedObject var reportViewModel: ReportViewModel
    @ObservedObject var observeViewModel = ObserveViewModel()
    @State var bottomSheetPosition: BottomSheetPosition = .middle
    @State var bottomSheetTranslation: CGFloat = BottomSheetPosition.middle.rawValue
    @State var hasDragged: Bool = false
    
    init(user: User) {
        self.user = user
        self.reportViewModel = ReportViewModel(user: user)
        self.observeViewModel = ObserveViewModel()
        }
    
    var bottomSheetTranslationProrated: CGFloat {
        (bottomSheetTranslation - BottomSheetPosition.middle.rawValue) / (BottomSheetPosition.top.rawValue - BottomSheetPosition.middle.rawValue)
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let screenHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
                let imageOffset = screenHeight + 36
                
                ZStack {
                    // MARK: Background Color
                    Color("darkGray")
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        HStack {
                            Text("Make a Report")
                        }
                            .font(.custom("chalkduster", size: 20))
                            .padding(10)
                            .cornerRadius(20)
                            .foregroundColor(Color("lightPink"))
                            .bold()
                        
                        // MARK: Make a report
                        VStack{
                            TextEditor(text: $observeViewModel.reportText)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .cornerRadius(20)
                                        .padding(8)
                                        .frame(width: 350, height: 180)
                                        .background(Color("darkPink"))
                                        .cornerRadius(20)
                            
                            HStack{
                                Spacer()
                                
                                Text("\(observeViewModel.reportText.count)/150")
                                    .font(.caption)
                                    .foregroundColor(Color("lightPink"))
                                    .padding(.trailing)
                                
                                Spacer()
                                    .frame(width: 28)
                                
                            }
                            
                            Button(action: {
                                            Task {
                                                // Add a send siren report method
                                                reportViewModel.addReport(reportText: observeViewModel.reportText)
                                                self.observeViewModel.reportText = ""
                                                print("sent")
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
                        }
                
                        HStack {
                            // MARK: Navigation Button
                            NavigationLink {
                                ReportView(user: user)
                            } label: {
                                Text("See other reports")
                                    .font(.custom("chalkduster", size: 15))
                                    .padding(10)
                                    .background(Color("darkPink"))
                                    .cornerRadius(20)
                                    .foregroundColor(Color("darkGray"))
                            }
                        }
                        .font(.title2)
                        .padding(EdgeInsets(top: 20, leading: 32, bottom: 24, trailing: 32))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        
                            Spacer()
                    }
                    .frame(height: max(0, geometry.size.height - 200))
                    
                    // MARK: Bottom Sheet
                    BottomSheetView(position: $bottomSheetPosition) {
//                        Text(bottomSheetTranslationProrated.formatted())
                    } content: {
                        ForecastView(user: user, bottomSheetTranslationProrated: bottomSheetTranslationProrated)
                    }
                    .onBottomSheetDrag { translation in
                        bottomSheetTranslation = translation / screenHeight
                        
                        withAnimation(.easeInOut) {
                            if bottomSheetPosition == BottomSheetPosition.top {
                                hasDragged = true
                            } else {
                                hasDragged = false
                            }
                        }
                    }
                    
                }
            }
            .navigationBarHidden(true)
        }
    }
}

