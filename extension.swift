import Foundation
import SwiftUI
import WidgetKit

extension Date {
    // date實例轉字串（最小單位為second）
    public static func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.dateFormat = "a h點m分s秒"
        let string = formatter.string(from: date)
        
        return string
    }
}
