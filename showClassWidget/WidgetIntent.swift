import Foundation
import AppIntents

// 確保此 Intent 只在特定版本的 iOS、macOS 和 watchOS 上可用
@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
struct WidgetIntent: AppIntent, WidgetConfigurationIntent, CustomIntentMigratedAppIntent {
    // 設定 Intent 的類名
    static let intentClassName = "WidgetIntentIntent"

    // 設定 Intent 的標題和描述
    static var title: LocalizedStringResource = "Widget Intent"
    static var description = IntentDescription("")

    // 定義一個參數，用於控制是否顯示當前或下一節課，預設值為 true
    @Parameter(title: "顯示下節/此節課(推薦)", default: true)
    var showingNowClass: Bool

    // 定義參數摘要，用於顯示參數配置
    static var parameterSummary: some ParameterSummary {
        Summary {
            \.$showingNowClass
        }
    }

    // 定義 Intent 執行的行為
    func perform() async throws -> some IntentResult {
        // TODO: 在此處放置重構的 Intent 處理程式碼
        return .result()
    }
}
