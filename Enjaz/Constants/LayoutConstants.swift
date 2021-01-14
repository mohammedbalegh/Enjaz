import UIKit

struct LayoutConstants {
	static let screenHeight = UIScreen.main.bounds.size.height
	static let screenWidth = UIScreen.main.bounds.size.width
    static let inputHeight = max(screenHeight * 0.07, 55)
	static let calendarViewPopoverCellHeight: CGFloat = 45
	static let calendarViewPopoverWidth: CGFloat = 200
    static let popupContainerWidth = screenWidth * 0.8
    static let sideMenuBtnHeight: CGFloat = 40
    static let tabBarHeight = screenHeight * 0.1
}
