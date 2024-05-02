//
//  LocationView.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 11/24/23.
//

import SwiftUI
import MapKit

struct LocationView: View {
    @StateObject private var viewModel: LocationViewModel
    @StateObject private var dataService = AlertPointerManager()
    @State private var iconScale: CGFloat = 3.0
    let user: User

    init(user: User) {
        self.user = user
        _viewModel = StateObject(wrappedValue: LocationViewModel(user: user))
    }

    var body: some View {
        Map(coordinateRegion: $viewModel.region,  annotationItems: validPointers) { pointer in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: pointer.latitude ?? 0.0, longitude: pointer.longitude ?? 0.0)) {
                       VStack {
                           CustomMapView(iconScale: $iconScale)
                                           .edgesIgnoringSafeArea(.all)
                           
                           Image(systemName: "ellipsis.circle.fill")
                               .symbolRenderingMode(.palette)
                               .foregroundStyle(Color("alertRed"))
                               .opacity(0.1)
                               .scaleEffect(iconScale)
                               .frame(width: 5000, height: 5000)
                       }
                   }
               }
               .onAppear {
                   DispatchQueue.main.async {
                       dataService.fetchPointers()
                       viewModel.checkIfLocationServicesIsEnabled()
                       }
            }
            .colorScheme(.dark)
            .frame(width: 400, height: 500)
            .padding(10)
            .background(Color("lightPurple"))
            .cornerRadius(20)
            
        Spacer()
    }
    
    
    private var validPointers: [AlertPointer] {
        print(dataService.pointers)
        let valid = dataService.pointers.filter { $0.latitude != nil && $0.longitude != nil }
        print("Valid pointers count: \(valid.count)")
        return valid
    }

}



