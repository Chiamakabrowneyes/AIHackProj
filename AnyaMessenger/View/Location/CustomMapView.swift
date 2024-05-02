//
//  MarkerDesign.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 2/15/24.
//

import SwiftUI
import MapKit

struct CustomMapView: UIViewRepresentable {
    @Binding var iconScale: CGFloat // Bind this to your SwiftUI state

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the view if needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView

        init(_ parent: CustomMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            // Infer the zoom level from the mapView's region span
            // This is a simplification; you might need a more sophisticated approach to accurately determine the zoom level
            let zoomWidth = mapView.region.span.longitudeDelta
            // Adjust the scale based on your zoom level logic
            let newScale: CGFloat = 3 // Determine this based on zoomWidth
            DispatchQueue.main.async {
                self.parent.iconScale = newScale
            }
        }
    }
}

