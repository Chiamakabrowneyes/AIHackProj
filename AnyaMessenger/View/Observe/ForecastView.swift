//
//  ForecastView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 1/10/24.
//

import SwiftUI

struct ForecastView: View {
    let user: User
    
    
    var bottomSheetTranslationProrated: CGFloat = 1
    @State private var selection = 0
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: Segmented Control
                SegmentedControl(selection: $selection)
                
                // MARK: Forecast Cards
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        if selection == 0 {
                            ForecastCard(mainText: "Siren calls per day within a 20 mile radius", detailText: "839", cardCondition: false)
                            ForecastCard(mainText: "The siren frequency in your area is above average. Be alert and feel free to access local emergency.", detailText: "", cardCondition: false)
                        
                        } else {
                            ForecastCard(mainText: "+234 782-8393-7878"
                                         + "\nWuse Police Department, 1410 Ethan Way, Abuja 900001", detailText: "Police Contact Info", cardCondition: true)
                            ForecastCard(mainText: "+234 097-6377-1093" +
                                         "\nDaughters of Charity Clinic, 14 Umorem St, Abuja 900001", detailText: "Ambulance Contact Info", cardCondition: true)
                            ForecastCard(mainText: "+234 887-1827-8982" +
                                         "\n Durumi Highway, 267 idomota St, Abuja 900001", detailText: "Fire Department Contact Info", cardCondition: true)
                            ForecastCard(mainText: "Contact Information: +234 112-2891-7393" +
                                         "\nMinistry of Justice, Abuja 900001", detailText: "Law Enforcement Contact Info",cardCondition: true)
                            
                        }
                    }
                    .padding(.vertical, 20)
                }
                .padding(.horizontal, 20)
                
                // MARK: Background Image
                LocationView(user: user)
            }
        }
        .backgroundBlur(radius: 25, opaque: true)
        .background(Color.bottomSheetBackground)
        .clipShape(RoundedRectangle(cornerRadius: 44))
        .innerShadow(shape: RoundedRectangle(cornerRadius: 44), color: Color.bottomSheetBorderMiddle, lineWidth: 1, offsetX: 0, offsetY: 1, blur: 0, blendMode: .overlay, opacity: 1 - bottomSheetTranslationProrated)
        .overlay {
            // MARK: Bottom Sheet Separator
            Divider()
                .blendMode(.overlay)
                .background(Color.bottomSheetBorderTop)
                .frame(maxHeight: .infinity, alignment: .top)
                .clipShape(RoundedRectangle(cornerRadius: 44))
        }
        .overlay {
            // MARK: Drag Indicator
            RoundedRectangle(cornerRadius: 10)
                .fill(.black.opacity(0.3))
                .frame(width: 48, height: 5)
                .frame(height: 20)
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}
