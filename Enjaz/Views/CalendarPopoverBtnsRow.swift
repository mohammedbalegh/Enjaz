import UIKit

class CalendarPopoverBtnsRow: UIView {
    enum PopoverBtnTypes {
        case calendarType, month, year, viewType
    }
    
    let popoverBtnsRowFontSize: CGFloat = 12.5
    
    lazy var calendarTypePopoverBtn: PopoverBtn = {
        let button = PopoverBtn(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.configure(withSize: .small)
        button.label.font = .systemFont(ofSize: popoverBtnsRowFontSize)
        button.isHidden = true
        
        return button
    }()
    
    lazy var monthPopoverBtn: PopoverBtn = {
        let button = PopoverBtn(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.configure(withSize: .small)
        button.label.font = .systemFont(ofSize: popoverBtnsRowFontSize)
        button.isHidden = true
        
        return button
    }()
    
    lazy var yearPopoverBtn: PopoverBtn = {
        let button = PopoverBtn(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.configure(withSize: .small)
        button.label.font = .systemFont(ofSize: popoverBtnsRowFontSize)
        button.isHidden = true
        
        return button
    }()
    
    lazy var viewTypePopoverBtn: PopoverBtn = {
        let button = PopoverBtn(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.configure(withSize: .small)
        button.label.font = .systemFont(ofSize: popoverBtnsRowFontSize)
        button.isHidden = true
        
        return button
    }()
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(firstBtn: PopoverBtnTypes? = nil, secondBtn: PopoverBtnTypes? = nil, thirdBtn: PopoverBtnTypes? = nil) {
        self.init(frame: .zero)
        
        showSpecifiedBtns(firstBtn, secondBtn, thirdBtn)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCalendarTypePopoverBtn()
        setupViewTypePopoverBtn()
        setupYearPopoverBtn()
        setupMonthPopoverBtn()
    }
    
    func setupCalendarTypePopoverBtn() {
        addSubview(calendarTypePopoverBtn)
        
        NSLayoutConstraint.activate([
            calendarTypePopoverBtn.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendarTypePopoverBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            calendarTypePopoverBtn.heightAnchor.constraint(equalTo: heightAnchor),
            calendarTypePopoverBtn.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: 0.26),
        ])
    }
    
    func setupViewTypePopoverBtn() {
        addSubview(viewTypePopoverBtn)
        
        NSLayoutConstraint.activate([
            viewTypePopoverBtn.leadingAnchor.constraint(equalTo: calendarTypePopoverBtn.trailingAnchor, constant: 15),
            viewTypePopoverBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            viewTypePopoverBtn.heightAnchor.constraint(equalTo: heightAnchor),
            viewTypePopoverBtn.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: 0.26),
        ])
    }
    
    func setupYearPopoverBtn() {
        addSubview(yearPopoverBtn)
        
        NSLayoutConstraint.activate([
            yearPopoverBtn.trailingAnchor.constraint(equalTo: trailingAnchor),
            yearPopoverBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            yearPopoverBtn.heightAnchor.constraint(equalTo: heightAnchor),
            yearPopoverBtn.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.16),
        ])
    }
    
    func setupMonthPopoverBtn() {
        addSubview(monthPopoverBtn)
        
        NSLayoutConstraint.activate([
            monthPopoverBtn.trailingAnchor.constraint(equalTo: yearPopoverBtn.leadingAnchor, constant: -15),
            monthPopoverBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            monthPopoverBtn.heightAnchor.constraint(equalTo: heightAnchor),
            monthPopoverBtn.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.22),
        ])
    }
    
    private func showSpecifiedBtns(_ firstBtn: PopoverBtnTypes?, _ secondBtn: PopoverBtnTypes?, _ thirdBtn: PopoverBtnTypes?) {
        for button in [firstBtn, secondBtn, thirdBtn] {
            switch button {
            case .calendarType:
                calendarTypePopoverBtn.isHidden = false
            case .month:
                monthPopoverBtn.isHidden = false
            case .year:
                yearPopoverBtn.isHidden = false
            case .viewType:
                viewTypePopoverBtn.isHidden = false
            default:
                break
            }
        }
    }
}
