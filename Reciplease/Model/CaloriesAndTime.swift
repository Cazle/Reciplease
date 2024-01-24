import Foundation

final class CaloriesAndTime {
    
    func formattingCalories(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        return "\(formatter.string(from: NSNumber(value: number)) ?? "") Cal"
    }
    
    private func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    func formatingHoursAndMinutes(time: Int) -> String {
        let (hours, minutes) = minutesToHoursAndMinutes(time)
        switch (hours, minutes) {
        case (0, 0):
            return ""
        case (1...24, 0):
            return"\(hours)h ⏱️"
        case (0, 0...60):
            return "\(minutes)m ⏱️"
        case (1...24, 0...60):
            return "\(hours)h\(minutes)m ⏱️"
        default:
            return "Error"
        }
    }
}

