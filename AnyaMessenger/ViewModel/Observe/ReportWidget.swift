//
//  WeatherWidget.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 1/10/24.
//

import SwiftUI

struct ReportWidget: View {
    var report: Report
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: Trapezoid
            Trapezoid()
                .fill(Color("darkPink"))
                .frame(width: 342, height: 174)
            Trapezoid()
                .fill(Color("darkPurple"))
                .frame(width: 342, height: 174)
                .rotationEffect(.degrees(180))
            
            // MARK: Content
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 8) {
                    VStack {
                        VStack(alignment: .leading, spacing: 2) {
                            // MARK: Forecast Temperature Range
                            Text(report.reportText)
                                .foregroundColor(Color.black)
                                .font(.custom("chalkduster", size: 13))
                                .padding(10)    // Adjust padding as needed
                                .bold()

                            Spacer() // This pushes everything else up and the last item to the bottom
                        }
                        .layoutPriority(1) // Ensures this VStack takes precedence in occupying available space

                        // This Text view is placed outside the inner VStack but inside the outer VStack,
                        // ensuring it's always at the bottom.
                        Text(report.address)
                            .foregroundColor(Color.black)
                            .font(.custom("chalkduster", size: 13))
                            .padding([.bottom], 10)
                            .bold()
                    }
                    .frame(width: 300, height: 150) // Specify the fixed size for the VStack
                    .cornerRadius(10) // Optional: Add a corner radius for rounded corners
                    .shadow(radius: 5) // Optional: Add a shadow for a subtle depth effect
                }
            }
            .padding(.bottom, 20)
            .padding(.leading, 20)
        }
        .frame(width: 342, height: 184, alignment: .bottom)
    }
}
