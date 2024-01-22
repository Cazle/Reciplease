import Foundation
import XCTest
@testable import Reciplease

final class CaloriesAndTimeTests: XCTestCase {
    
    func test_convertingDecimal() {
        let sut = CaloriesAndTime()
        
        let calories = 3024.3725
        
        let formattedCalories = sut.formattingCalories(calories)
        
        XCTAssertEqual(formattedCalories, "3 024 Cal")
    }
    func test_whenThereIsNoNumber() {
        let sut = CaloriesAndTime()
        
        let calories = Double()
        
        let formattedCalories = sut.formattingCalories(calories)
        
        XCTAssertEqual(formattedCalories, "0 Cal")
    }
    func test_whenThereIsNoTimerOnARecipe() {
        
        let sut = CaloriesAndTime()
        
        let time = 0
        
        let formattedTime = sut.formatingHoursAndMinutes(time: time)
        
        XCTAssertEqual(formattedTime, "")
    }
    func test_whenThereIsOnlyHoursOnARecipe() {
        
        let sut = CaloriesAndTime()
        
        let time = 60
        
        let formattedTime = sut.formatingHoursAndMinutes(time: time)
        
        XCTAssertEqual(formattedTime, "1h ⏱️")
    }
    func test_whenThereIsOnlyMinutesOnARecipe() {
        let sut = CaloriesAndTime()
        
        let time = 45
        
        let formattedTime = sut.formatingHoursAndMinutes(time: time)
        
        XCTAssertEqual(formattedTime, "45m ⏱️")
    }
    func test_whenThereIsHoursAndMinutesOnARecipe() {
        let sut = CaloriesAndTime()
        
        let time = 90
        
        let formattedTime = sut.formatingHoursAndMinutes(time: time)
        
        XCTAssertEqual(formattedTime, "1h30m ⏱️")
    }
    func test_theDefaultCase() {
        let sut = CaloriesAndTime()
        
        let time = 9999
        
        let formattedTime = sut.formatingHoursAndMinutes(time: time)
        
        XCTAssertEqual(formattedTime, "Error")
    }
}
