import Foundation

struct DateAndTimeTools {
    static let twelveHourFormatHourLabels = ["12 AM"] + (1...11).map { "\($0) AM" } + ["12 PM"] + (1...11).map { "\($0) PM" }
    
    static func getCurrentDay(forCalendarIdentifier calendarIdentifier: Calendar.Identifier) -> Int {
        return getCurrentCalendarComponent(for: .day, andCalendarIdentifier: calendarIdentifier)
    }
    
    static func getCurrentMonth(forCalendarIdentifier calendarIdentifier: Calendar.Identifier) -> Int {
        return getCurrentCalendarComponent(for: .month, andCalendarIdentifier: calendarIdentifier)
    }
    
    static func getCurrentYear(forCalendarIdentifier calendarIdentifier: Calendar.Identifier) -> Int {
        return getCurrentCalendarComponent(for: .year, andCalendarIdentifier: calendarIdentifier)
    }
    
    private static func getCurrentCalendarComponent(for calendarComponent: Calendar.Component, andCalendarIdentifier calendarIdentifier: Calendar.Identifier) -> Int {
        let date = Date()
        let calendar = Calendar(identifier: calendarIdentifier)
        
        let component = calendar.component(calendarComponent, from: date)
        return component
    }
    
    static func getNumberOfMonthDaysAndFirstWeekDay(ofYear year: Int, andMonth month: Int, forCalendarIdentifier calendarIdentifier: Calendar.Identifier) -> (Int, Int) {
        let dateComponents = DateComponents(year: year, month: month, day: 1)
        let calendar = Calendar(identifier: calendarIdentifier)
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)
        let numberOfDays = range?.count ?? 0
        
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
    
    static func generateDateObjectFromComponents(year: Int, month: Int, day: Int, hour: Int, calendarIdentifier: Calendar.Identifier) -> Date {
        
        let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour)
        let calendar = Calendar(identifier: calendarIdentifier)
        let date = calendar.date(from: dateComponents)!
        
        return date
    }
        
    static func getReadableDate(from date: Date?, withFormat format: String, calendarIdentifier: Calendar.Identifier) -> String {
        guard let date = date else { return "-" }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.dateFormat = format
        
        if calendarIdentifier == .islamicCivil {
            let islamicCalendar = Calendar(identifier: .islamicCivil)
            formatter.calendar = islamicCalendar
        }
        
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "en_US")
        let currentDate = formatter.string(from: date)
        
        return currentDate
    }
    
    static func getDateAndTimeLabelText(_ viewModel: ItemModel) -> NSAttributedString {
        let itemDate = Date(timeIntervalSince1970: viewModel.date)
        let dateFormat: String = {
            if viewModel.is_repeated { return "d/M/yy" }
            if Calendar.current.isDateInToday(itemDate) { return "hh:00  aa" }
            return "d/M/yyyy hh:00  aa"
        }()
        
        let readableStartDate = DateAndTimeTools.getReadableDate(from: itemDate, withFormat: dateFormat, calendarIdentifier: Calendar.current.identifier)
        let readableEndDate: String = {
            guard viewModel.is_repeated else { return "" }
            
            let itemEndDate = Date(timeIntervalSince1970: viewModel.end_date)
            return DateAndTimeTools.getReadableDate(from: itemEndDate, withFormat: dateFormat, calendarIdentifier: Calendar.current.identifier)
        }()
        
        let from = NSLocalizedString("from", comment: "")
        let to = NSLocalizedString("to", comment: "")
        
        let rangeDate = "\(from) \(readableStartDate) \(to) \(readableEndDate)".attributedStringWithColor([from, to], color: .accent, stringSize: 11, coloredSubstringsSize: 11)
        
        let itemReadableDate = viewModel.is_repeated
            ? rangeDate
            : NSAttributedString(string: readableStartDate)
        
        return itemReadableDate
    }
    
    static func convertHourModelTo24HrFormatInt(_ hourModel: HourModel) -> Int {
		if hourModel.hour == 12 {
			return hourModel.period == "pm" ? 12 : 0
		}
        
        return hourModel.period == "pm" ? (hourModel.hour + 12) % 24 : hourModel.hour
    }
	
	static func convert12HourFormatTo24HrFormatInt(_ hourString: String) -> Int? {		
		let splitString = hourString.split(separator: " ")
		guard let hour = Int(splitString.first ?? "") else { return nil }
		guard let period = splitString.last?.lowercased() else { return nil }
		
		if hour == 12 {
			return period == "pm" ? 12 : 0
		}
		
		return period == "pm" ? (hour + 12) % 24 : hour
	}
    
	static func getDateComponentsOf(_ date: Date, forCalendarIdentifier calendarIdentifier: Calendar.Identifier) -> DateComponents {
		let calendar = Calendar(identifier: calendarIdentifier)
		let dateComponents = calendar.dateComponents([.minute, .hour, .day, .month, .year], from: date)
		
		return dateComponents
	}
	
    static func getDateComponentsOf(unixTimeStamp: TimeInterval, forCalendarIdentifier calendarIdentifier: Calendar.Identifier) -> DateComponents {
        let date = Date(timeIntervalSince1970: unixTimeStamp)
		return getDateComponentsOf(date, forCalendarIdentifier: calendarIdentifier)
    }
    
    static func getFirstAndLastUnixTimeStampsOfCurrentMonth(forCalendarIdentifier calendarIdentifier: Calendar.Identifier) -> (Double, Double) {
        let currentYear = getCurrentYear(forCalendarIdentifier: calendarIdentifier)
        let currentMonth = getCurrentMonth(forCalendarIdentifier: calendarIdentifier)
        let (numberOfMonthDays, _) =  getNumberOfMonthDaysAndFirstWeekDay(ofYear: currentYear, andMonth: currentMonth, forCalendarIdentifier: calendarIdentifier)
        
        let firstDayUnixTimeStamp = generateDateObjectFromComponents(year: currentYear, month: currentMonth, day: 1, hour: 0, calendarIdentifier: calendarIdentifier).timeIntervalSince1970
        
        let lastDayUnixTimeStamp = generateDateObjectFromComponents(year: currentYear, month: currentMonth, day: numberOfMonthDays, hour: 23, calendarIdentifier: calendarIdentifier).timeIntervalSince1970
                
        return (firstDayUnixTimeStamp, lastDayUnixTimeStamp)
    }
    
    static func isDateInCurrentWeek(date: Date, calendarIdentifier: Calendar.Identifier) -> Bool {
        let calendar = Calendar(identifier: calendarIdentifier)
        let currentComponents = calendar.dateComponents([.weekOfYear], from: Date())
        let dateComponents = calendar.dateComponents([.weekOfYear], from: date)
        guard let currentWeekOfYear = currentComponents.weekOfYear, let dateWeekOfYear = dateComponents.weekOfYear else { return false }
        return currentWeekOfYear == dateWeekOfYear
    }
    
    static func getNumberOfDaysBetween(_ firstDate: Date, _ secondDate: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: firstDate, to: secondDate).day
    }
}
