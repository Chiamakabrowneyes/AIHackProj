//
//  ForecastCard.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 1/10/24.
//

import SwiftUI

struct ForecastCard: View {
    var mainText: String  // New parameter for main text
    var detailText: String
    var cardCondition: Bool

    
    var body: some View {
        ZStack {
            // MARK: Card
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.forecastCardBackground.opacity(0.2))
                .frame(width: cardCondition ? 380 : 190, height: 146)
                .shadow(color: .black.opacity(0.25), radius: 10, x: 5, y: 4)
                .overlay {
                    // MARK: Card Border
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(.white.opacity( 0.5 ))
                        .blendMode(.overlay)
                }
                .innerShadow(shape: RoundedRectangle(cornerRadius: 30), color: .white.opacity(0.25), lineWidth: 1, offsetX: 1, offsetY: 1, blur: 0, blendMode: .overlay)
            
            // MARK: Content
            VStack(spacing: 16) {
                VStack() {
                    if detailText != ""{
                        Text(detailText)
                            .font(.system(size: cardCondition ? 25 : 40))
                            .foregroundColor(Color("darkPink"))
                            .opacity(1)
                            .padding(5)
                    }
                    Text(mainText)
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(Color("darkPink"))
                        .opacity(1)
                        .padding(5)
                        .multilineTextAlignment(.center) // Aligns the text in the center for each line
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 16)
            .frame(width: cardCondition ? 380 : 190, height: 146)
        }
    }
}
