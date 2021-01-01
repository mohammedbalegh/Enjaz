import UIKit

struct LayoutConstants {
	static let screenHeight = UIScreen.main.bounds.size.height
	static let screenWidth = UIScreen.main.bounds.size.width
    static let largePrimaryBtnHeight = screenHeight * 0.06
    static let smallPrimaryBtnHeight = screenHeight * 0.053
	static let textFieldsHeight = max(screenHeight * 0.085, 50)
	static let toolBarHeight = screenHeight * 0.16
	static let navBarItemWidth = screenWidth * 0.053
	static let navBarItemHeight = navBarItemWidth * 1.2
    static let inputHeight = max(screenHeight * 0.07, 40)
	static let calendarViewWidth = screenWidth * 0.95
	static let calendarViewPopoverCellHeight: CGFloat = 45
	static let calendarViewPopoverWidth: CGFloat = 200
    static let popupContainerWidth = screenWidth * 0.8
    static let sideMenuBtnHeight: CGFloat = 40
}
