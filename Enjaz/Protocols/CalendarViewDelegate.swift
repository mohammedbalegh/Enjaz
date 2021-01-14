protocol CalendarViewDelegate {
    func didUpdateFirstSelectedMonthDayItemRow(_ calendarView: CalendarView)
    func didUpdateLastSelectedMonthDayItemRow(_ calendarView: CalendarView)
    func didLongPressOnLastItemDuringMultipleSelection(_ calendarView: CalendarView)
}
