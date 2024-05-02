//
//  ObserveViewModel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 2/17/24.
//

import Foundation

class ObserveViewModel: ObservableObject {
    @Published var reportText = "" {
        didSet {
            if reportText.count > 150 && oldValue.count <= 150 {
                reportText = oldValue
            }
        }
    }
}
