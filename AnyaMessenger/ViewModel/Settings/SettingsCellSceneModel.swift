//
//  SettlingsCellViewModel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 9/30/23.
//

import SwiftUI

enum SettingsCellSceneModel: Int, CaseIterable {
    case optimize
    case addContact
    case removeContacts
    
    var title: String {
        switch self {
        case .optimize: return "Optimize Your Siren Calls "
        case .addContact: return "Add New Siren Contacts"
        case .removeContacts: return "Remove Select Siren Contacts"
        }
    }
    
    var imageName: String {
        switch self {
        case .optimize: return "brain.head.profile"
        case .addContact: return "at.badge.plus"
        case .removeContacts: return "person.badge.minus.fill"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .optimize: return Color("darkPink")
        case .addContact: return Color("darkPink")
        case .removeContacts: return Color("darkPink")
        }
    }
}
