import Foundation

final class FormatAndTime {
    func formattingLikes(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        
        if number < 1000 {
            let convertIntoInt = Int(number)
            return formatter.string(from: NSNumber(value: convertIntoInt)) ?? ""
        } else {
            let formatedNumber = number / 1000.0
            return "\(formatter.string(from: NSNumber(value: formatedNumber)) ?? "")k"
        }
    }
    private func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }
    func formatingHoursAndMinutes(minutes: Int) -> String {
        let (hours, minutes) = minutesToHoursAndMinutes(minutes)
        switch (hours, minutes) {
        case (0, 0):
            return ""
        case (1...24, 0):
            return"\(hours)h ⏱️"
        case (0, 0...60):
            return "\(minutes)m ⏱️"
        case (1...10, 0...60):
            return "\(hours)h\(minutes)m ⏱️"
        default:
            return "Error"
        }
    }
}

