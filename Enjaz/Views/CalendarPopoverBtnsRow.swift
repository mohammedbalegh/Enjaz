import UIKit

class CalendarPopoverBtnsRow: UIView {
    let popoverBtnsRowFontSize: CGFloat = 12.5
    
    lazy var calendarTypePopoverBtn: PopoverBtn = {
        let button = PopoverBtn(type: .custom)
        
        button.configure(withSize: .small)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.label.font = .systemFont(ofSize: popoverBtnsRowFontSize)
        
        return button
    }()
    
    lazy var monthPopoverBtn: PopoverBtn = {
        let button = PopoverBtn(type: .custom)
        
        button.configure(withSize: .small)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.label.font = .systemFont(ofSize: popoverBtnsRowFontSize)
        
        return button
    }()
    
    lazy var yearPopoverBtn: PopoverBtn = {
        let button = PopoverBtn(type: .custom)
        
        button.configure(withSize: .small)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.label.font = .systemFont(ofSize: popoverBtnsRowFontSize)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        setupCalendarTypePopoverBtn()
        setupYearPopoverBtn()
        setupMonthPopoverBtn()
    }
    
    func setupCalendarTypePopoverBtn() {
        addSubview(calendarTypePopoverBtn)
        
        NSLayoutConstraint.activate([
            calendarTypePopoverBtn.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendarTypePopoverBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            calendarTypePopoverBtn.heightAnchor.constraint(equalTo: heightAnchor),
            calendarTypePopoverBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.26),
        ])
    }
    
    func setupYearPopoverBtn() {
        addSubview(yearPopoverBtn)
        
        NSLayoutConstraint.activate([
            yearPopoverBtn.trailingAnchor.constraint(equalTo: trailingAnchor),
            yearPopoverBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            yearPopoverBtn.heightAnchor.constraint(equalTo: heightAnchor),
            yearPopoverBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.14),
        ])
    }
    
    func setupMonthPopoverBtn() {
        addSubview(monthPopoverBtn)
        
        NSLayoutConstraint.activate([
            monthPopoverBtn.trailingAnchor.constraint(equalTo: yearPopoverBtn.leadingAnchor, constant: -15),
            monthPopoverBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            monthPopoverBtn.heightAnchor.constraint(equalTo: heightAnchor),
            monthPopoverBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.18),
        ])
    }
        
}
