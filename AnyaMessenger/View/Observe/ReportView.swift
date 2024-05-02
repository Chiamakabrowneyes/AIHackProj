//
//  WeatherView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 1/10/24.
//

import SwiftUI

struct ReportView: View {
    let user: User
    @StateObject var reportViewModel: ReportViewModel
    @State private var searchText = ""
    
    init(user: User) {
        self.user = user
        _reportViewModel = StateObject(wrappedValue: ReportViewModel(user: user))
        }
        
    var searchResults: [Report] {
        // Filter reports based on search text, if any
        let filteredReports = searchText.isEmpty ? reportViewModel.reports : reportViewModel.reports.filter { $0.address.contains(searchText) || $0.reportText.contains(searchText) }

        // Sort reports by timestamp in descending order so the newest reports come first
        return filteredReports.sorted(by: { $0.timestamp > $1.timestamp })
    }

    
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: Background
                Color("darkGray")
                    .ignoresSafeArea()
                
                // MARK: Weather Widgets
                ScrollView(showsIndicators: false) {
                    //populate this loop to contain the reporttexts and address values from firestore instead
                    VStack(spacing: 20) {
                        ForEach(searchResults) { report in
                            ReportWidget(report: report)
                        }
                    }
                }
                .safeAreaInset(edge: .top) {
                    EmptyView()
                        .frame(height: 70)
                }
            }
            .overlay {
                // MARK: Navigation Bar
                NavigationBar(searchText: $searchText)
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            reportViewModel.fetchReports() 
        }
    }
}
