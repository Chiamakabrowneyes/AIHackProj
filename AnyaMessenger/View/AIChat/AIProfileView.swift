//
//  AIProfileView.swift
//  AnyaMessenger
//
//  Created by Chiamaka U on 3/3/24.
//

import Foundation
import SwiftUI

struct AIProfileView: View {
    @State var apiKey: String = UserDefaults.standard.string(forKey: "openai_api_key") ?? ""
    var body: some View {
        List {
            Section("OpenAI API Key") {
                TextField("Enter key", text: $apiKey) {
                    UserDefaults.standard.set(apiKey, forKey: "openai_api_key")
                }
            }
        }
    }
}
