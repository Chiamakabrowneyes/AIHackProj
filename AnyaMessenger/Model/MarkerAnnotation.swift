//
//  MapAnnotation.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 2/15/24.
//

import Foundation
import MapKit

struct MarkerAnnotation: Identifiable {
    let id: UUID
    var coordinate: CLLocationCoordinate2D
    var title: String?

    init(coordinate: CLLocationCoordinate2D, title: String? = nil) {
        self.id = UUID() // Assign a unique ID
        self.coordinate = coordinate
        self.title = title
    }
}
