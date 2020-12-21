import UIKit

class PopoverCalendarBtnsStackView: UIStackView {
	let popoverBtnsRowFontSize: CGFloat = 12.5
	
	lazy var calendarTypePopoverBtn: PopoverBtn = {
		let button = PopoverBtn(frame: CGRect(x: 0, y: 0, width: 100, height: frame.height))
		button.label.font = .systemFont(ofSize: popoverBtnsRowFontSize)
		
		return button
	}()
	
	lazy var monthPopoverBtn: PopoverBtn = {
		let button = PopoverBtn(frame: CGRect(x: 0, y: 0, width: 70, height: frame.height))
		button.label.font = .systemFont(ofSize: popoverBtnsRowFontSize)
		
		return button
	}()
	
	lazy var yearPopoverBtn: PopoverBtn = {
		let button = PopoverBtn(frame: CGRect(x: 0, y: 0, width: 55, height: frame.height))
		button.label.font = .systemFont(ofSize: popoverBtnsRowFontSize)
		
		return button
	}()
		
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		distribution = .fillEqually
		alignment = .center
		
		addArrangedSubview(calendarTypePopoverBtn)
		addArrangedSubview(monthPopoverBtn)
		addArrangedSubview(yearPopoverBtn)
		
		setCustomSpacing(LayoutConstants.screenWidth * 0.13, after: calendarTypePopoverBtn)
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
