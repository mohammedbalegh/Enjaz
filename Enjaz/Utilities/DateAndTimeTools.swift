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
    
    static func genrateDateObjectFromComponents(year: Int, month: Int, day: Int, hour: Int, calendarIdentifier: NSCalendar.Identifier) -> Date {
        
        let dateComponents = DateComponents(year: year, month: month, day: 1, hour: hour)
        let calendar = NSCalendar(identifier: calendarIdentifier)!
        let date = calendar.date(from: dateComponents)!

        return date
    }
    
}
