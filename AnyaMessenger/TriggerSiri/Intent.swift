//
//  Intent.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 1/31/24.
//

import Foundation
import AppIntents

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
struct Intent: AppIntent, WidgetConfigurationIntent, CustomIntentMigratedAppIntent, PredictableIntent {
    static let intentClassName = "IntentIntent"

    static var title: LocalizedStringResource = "Trigger Siren Call Intent"
    static var description = IntentDescription("Send the siren calls to emergency contacts")
    lazy var sirenViewModel: SirenView = {
            let user = AuthSceneModel.shared.currentUser
        return SirenView(user: user!)
        }()

    @Parameter(title: "Siren Call Trigger")
    var parameter: String?

    static var parameterSummary: some ParameterSummary {
        Summary {
            \.$parameter
        }
    }

    static var predictionConfiguration: some IntentPredictionConfiguration {
        IntentPrediction(parameters: (\.$parameter)) { parameter in
            DisplayRepresentation(
                title: "Trigger ",
                subtitle: "Send Emergency Siren calls with Siri... Use your own unique phrase"
            )
        }
    }

}


