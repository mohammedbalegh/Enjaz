import UIKit

class MonthItemsScreenVC: UIViewController {
    
    let cardsReuseIdentifier = "cardCell"
    
    let searchTextField = UITextField()
    let progressView = UIView()
        
    var dayItemModels: [ItemModel] = []
    var weekItemModels: [ItemModel] = []
    var monthItemModels: [ItemModel] = []
    var completedItemModels: [ItemModel] = []
    
    var currentMonthItems: [ItemModel] = []
    
    let scrollView = UIScrollView()
    var itemsType: Int!
    
    lazy var dayItemsView: CardsView = {
        let cardsView = CardsView()
        cardsView.translatesAutoresizingMaskIntoConstraints = false
        
        cardsView.cardsCollectionView.register(ItemCardCell.self, forCellWithReuseIdentifier: cardsReuseIdentifier)
        cardsView.cardsCollectionView.delegate = self
        cardsView.cardsCollectionView.dataSource = self
        
        cardsView.cardsCount = dayItemModels.count
        cardsView.header.showAllButton.addTarget(self, action: #selector(handleShowAllDayItemsBtnTap), for: .touchUpInside)
        
        return cardsView
    }()
    
    lazy var weekItemsView: CardsView = {
        let cardsView = CardsView()
        cardsView.translatesAutoresizingMaskIntoConstraints = false
        
        cardsView.cardsCollectionView.register(ItemCardCell.self, forCellWithReuseIdentifier: cardsReuseIdentifier)
        cardsView.cardsCollectionView.delegate = self
        cardsView.cardsCollectionView.dataSource = self
        
        cardsView.cardsCount = dayItemModels.count
        cardsView.header.showAllButton.addTarget(self, action: #selector(handleShowAllWeekItemsBtnTap), for: .touchUpInside)
        
        return cardsView
    }()
    
    lazy var monthItemsView: CardsView = {
        let cardsView = CardsView()
        cardsView.translatesAutoresizingMaskIntoConstraints = false
        
        cardsView.cardsCollectionView.register(ItemCardCell.self, forCellWithReuseIdentifier: cardsReuseIdentifier)
        cardsView.cardsCollectionView.delegate = self
        cardsView.cardsCollectionView.dataSource = self
        
        cardsView.cardsCount = dayItemModels.count
        cardsView.header.showAllButton.addTarget(self, action: #selector(handleShowAllMonthItemsBtnTap), for: .touchUpInside)
        
        return cardsView
    }()
    
    lazy var completedItemsView: CardsView = {
        let cardsView = CardsView()
        cardsView.translatesAutoresizingMaskIntoConstraints = false
        
        cardsView.cardsCollectionView.register(ItemCardCell.self, forCellWithReuseIdentifier: cardsReuseIdentifier)
        cardsView.cardsCollectionView.delegate = self
        cardsView.cardsCollectionView.dataSource = self
        
        cardsView.cardsCount = dayItemModels.count
        cardsView.header.showAllButton.addTarget(self, action: #selector(handleShowAllCompletedItemsBtnTap), for: .touchUpInside)
        
        return cardsView
    }()
    
    lazy var itemViewsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dayItemsView, weekItemsView, monthItemsView, completedItemsView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 60
        
        return stackView
    }()
    
    let cardPopup = CardPopup(hideOnOverlayTap: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainScreenBackgroundColor
        setItemCardViewsTitles()
        setupSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateScreen()
    }
    
    func setupSubViews() {
        setupScrollView()
        setupItemViewsStack()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.fillSuperView()
    }
    
    func setupItemViewsStack() {
        scrollView.addSubview(itemViewsStack)
        
        let height = itemViewsStack.calculateHeightBasedOn(arrangedSubviewHeight: 240)
        
        NSLayoutConstraint.activate([
            itemViewsStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            itemViewsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemViewsStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            itemViewsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemViewsStack.heightAnchor.constraint(equalToConstant: height),
        ])
    }
    
    // MARK: Event Handlers
    
    @objc func handleShowAllDayItemsBtnTap() {
        navigateToShowAllItemsScreen(withModels: dayItemModels, title: dayItemsView.title)
    }
    
    @objc func handleShowAllWeekItemsBtnTap() {
        navigateToShowAllItemsScreen(withModels: weekItemModels, title: weekItemsView.title)
    }
    
    @objc func handleShowAllMonthItemsBtnTap() {
        navigateToShowAllItemsScreen(withModels: monthItemModels, title: monthItemsView.title)
    }
    
    @objc func handleShowAllCompletedItemsBtnTap() {
        navigateToShowAllItemsScreen(withModels: completedItemModels, title: completedItemsView.title)
    }
        
    // MARK: Tools
    
    // @abstract
    func setItemCardViewsTitles() {}
        
    func updateScreen() {
        updateItemModels()
        updateItemViews()
    }
    
    func updateItemModels() {
        let (firstDayUnixTimeStamp, lastDayUnixTimeStamp) = DateAndTimeTools.getFirstAndLastUnixTimeStampsOfCurrentMonth(forCalendarIdentifier: Calendar.current.identifier)
        
        currentMonthItems = RealmManager.retrieveItems(withFilter: "date >= \(firstDayUnixTimeStamp) AND date <= \(lastDayUnixTimeStamp)").filter { $0.type == itemsType }
                
        dayItemModels = currentMonthItems.filter { Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.date)) }
        
        weekItemModels = currentMonthItems.filter { DateAndTimeTools.isDateInCurrentWeek(date: Date(timeIntervalSince1970: $0.date), calendarIdentifier: Calendar.current.identifier) }
        
        monthItemModels = currentMonthItems
        
        completedItemModels = currentMonthItems.filter { $0.is_completed }
    }
    
    func updateItemViews() {
        for arrangedSubview in itemViewsStack.arrangedSubviews {
            if let cardsView = arrangedSubview as? CardsView {
                cardsView.cardsCollectionView.reloadData()
                let cardsViewModels = getViewModels(for: cardsView.cardsCollectionView)
                cardsView.cardsCount = cardsViewModels.count
            }
        }
    }
    
    func navigateToShowAllItemsScreen(withModels models: [ItemModel], title: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let showAllItemsScreenVC = ShowAllItemsScreenVC(collectionViewLayout: layout)
        showAllItemsScreenVC.cardModels = models
        showAllItemsScreenVC.title = title
        
        navigationController?.pushViewController(showAllItemsScreenVC, animated: true)
    }
    
}

extension MonthItemsScreenVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let viewModels = getViewModels(for: collectionView)
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardsReuseIdentifier, for: indexPath) as! ItemCardCell
        
        let viewModels = getViewModels(for: collectionView)
        cell.viewModel = viewModels[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.screenHeight * 0.0205
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2.5), height: (collectionView.frame.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let offSet = LayoutConstants.screenWidth * 0.054
        return UIEdgeInsets(top: 0, left: offSet, bottom: 0, right: offSet)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ItemCardCell
        cardPopup.viewModel = cell.cardView
        cardPopup.show()
    }
    
    func getViewModels(for collectionView: UICollectionView) -> [ItemModel] {
        switch collectionView {
        case dayItemsView.cardsCollectionView: return dayItemModels
        case weekItemsView.cardsCollectionView: return weekItemModels
        case monthItemsView.cardsCollectionView: return monthItemModels
        case completedItemsView.cardsCollectionView: return completedItemModels
        default: return []
        }
    }
}
