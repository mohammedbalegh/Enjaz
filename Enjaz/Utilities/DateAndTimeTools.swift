import Foundation

class DateAndTimeTools {
	
    static func getCurrentYear(islamic: Bool) -> Int {
        let date = Date()
        let calendar = NSCalendar(identifier: islamic ? .islamicCivil : .gregorian)!
        
        let year = calendar.component(.year, from: date)
        return year
    }
	
	static func getNumberOfMonthDaysAndFirstWeekDay(ofYear year: Int, andMonth month: Int, forCalendarType calendarIdentifier: NSCalendar.Identifier) -> (Int, Int) {
		let dateComponents = DateComponents(year: year, month: month, day: 1)
		let calendar = NSCalendar(identifier: calendarIdentifier)!
		let date = calendar.date(from: dateComponents)!
		
		let range = calendar.range(of: .day, in: .month, for: date)
		let numberOfDays = range.length
		
		let georgianWeekDay = calendar.component(.weekday, from: date)
		
		let weekDay = mapWeekGeorgianWeekDayToIslamicWeekDay(georgianWeekDay)
		
		return (numberOfDays, weekDay)
	}
	
	static func mapWeekGeorgianWeekDayToIslamicWeekDay(_ georgianWeekDay: Int) -> Int {
		let map = [
			1 : 2,
			2 : 3,
			3 : 4,
			4 : 5,
			5 : 6,
			6 : 7,
			7 : 1,
		]
		
		return map[georgianWeekDay] ?? 0
	}
    
    static func generateDateObjectFromComponents(year: Int, month: Int, day: Int, hour: Int, calendarIdentifier: NSCalendar.Identifier) -> Date {
        
        let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour)
        let calendar = NSCalendar(identifier: calendarIdentifier)!
        let date = calendar.date(from: dateComponents)!

        return date
    }
    
    static func getDateInIslamic() -> String {
        let today = Date()
        let islamic = Calendar(identifier: .islamic)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.dateFormat = "dd MMMM"
        formatter.calendar = islamic
        formatter.locale = Locale(identifier: "ar_DZ")
        let currentDate = formatter.string(from: today)
        
        return currentDate
    }
    
    static func getDate() -> String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ar_DZ")
        let currentDate = formatter.string(from: today)
        return currentDate
    }
    
    static func getReadableDate(from date: Date, withFormat format: String, calendarIdentifier: NSCalendar.Identifier) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.dateFormat = format
        
        if (calendarIdentifier == .islamic) {
            let islamicCalendar = Calendar(identifier: .islamic)
            formatter.calendar = islamicCalendar
        }
        
        formatter.locale = Locale(identifier: "ar_DZ")
        let currentDate = formatter.string(from: date)
        
        return currentDate
    }
    
}
