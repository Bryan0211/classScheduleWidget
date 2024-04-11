//
//  WidgetIntent.swift
//  showClassWidgetExtension
//
//  Created by 游尚諺 on 2024/4/11.
//

import Foundation
import AppIntents

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
struct WidgetIntent: AppIntent, WidgetConfigurationIntent, CustomIntentMigratedAppIntent {
    static let intentClassName = "WidgetIntentIntent"

    static var title: LocalizedStringResource = "Widget Intent"
    static var description = IntentDescription("")

    @Parameter(title: "顯示下節/此節課(推薦)", default: true)
    var showingNowClass: Bool

    static var parameterSummary: some ParameterSummary {
        Summary {
            \.$showingNowClass
        }
    }

    func perform() async throws -> some IntentResult {
        // TODO: Place your refactored intent handler code here.
        return .result()
    }
}
