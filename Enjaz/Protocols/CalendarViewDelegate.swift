import UIKit

protocol CalendarViewDelegate {
    func didUpdateFirstSelectedMonthDayItemRow(_ calendarView: CalendarView)
    func didUpdateLastSelectedMonthDayItemRow(_ calendarView: CalendarView)
    func didLongPressOnLastItemDuringMultipleSelection(_ calendarView: CalendarView)
    func calendarCollectionView(_ calendarCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

extension CalendarViewDelegate {
    func didUpdateFirstSelectedMonthDayItemRow(_ calendarView: CalendarView) {}
    func didUpdateLastSelectedMonthDayItemRow(_ calendarView: CalendarView) {}
    func didLongPressOnLastItemDuringMultipleSelection(_ calendarView: CalendarView) {}
    func calendarCollectionView(_ calendarCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}
