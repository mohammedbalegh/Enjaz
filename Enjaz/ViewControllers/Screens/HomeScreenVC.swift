import UIKit

class HomeScreenVC: UIViewController {
    
    // MARK: Properties
    
    var goalModels: [ItemModel] = [] {
        didSet {
            dailyGoalView.cardsCollectionView.reloadData()
        }
    }
    
    var demahModels: [ItemModel] = [] {
        didSet {
            dailyDemahView.cardsCollectionView.reloadData()
        }
    }
    
    let cardsReuseIdentifier = "cardCell"
    
    let cardPopup = CardPopup(hideOnOverlayTap: true)
    let itemsViewHeight = LayoutConstants.screenHeight * 0.27
    
    lazy var greetingMessageView: GreetingMessageView = {
        let view = GreetingMessageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let mode = getHour()
        let name = user?.name ?? ""
        let firstName = String(name.split(separator: " ")[0])
        
        if mode == "am" {
            view.image.image = UIImage(named: "sunIcon")
            view.welcomeLabel.text = String(format: NSLocalizedString("Good morning %@!", comment: ""), firstName)
            view.messageLabel.text = NSLocalizedString("Take a look at today's goals and habits", comment: "")
        } else {
            view.image.image = UIImage(named: "moonIcon")
            view.welcomeLabel.text = String(format: NSLocalizedString("Good evening %@!", comment: ""), firstName)
            view.messageLabel.text = NSLocalizedString("Take a look at today's remaining goals", comment: "")
        }
        
        return view
    }()
    
    lazy var dailyGoalView: CardsView = {
        let cardsView = CardsView()
        cardsView.translatesAutoresizingMaskIntoConstraints = false
        
        cardsView.cardsCollectionView.register(ItemCardCell.self, forCellWithReuseIdentifier: cardsReuseIdentifier)
        cardsView.cardsCollectionView.delegate = self
        cardsView.cardsCollectionView.dataSource = self
        
        cardsView.title = NSLocalizedString("Today's goals", comment: "")
        cardsView.noCardsMessage = NSLocalizedString("No goals today", comment: "")
        cardsView.cardsCount = goalModels.count
        cardsView.header.showAllButton.addTarget(self, action: #selector(handleShowAllGoalsBtnTap), for: .touchUpInside)
        
        return cardsView
    }()
    
    lazy var dailyDemahView: CardsView = {
        let cardsView = CardsView()
        cardsView.translatesAutoresizingMaskIntoConstraints = false
        
        cardsView.cardsCollectionView.register(ItemCardCell.self, forCellWithReuseIdentifier: cardsReuseIdentifier)
        cardsView.cardsCollectionView.delegate = self
        cardsView.cardsCollectionView.dataSource = self
        
        cardsView.title = NSLocalizedString("Today's demahs", comment: "")
        cardsView.noCardsMessage = NSLocalizedString("No demahs today", comment: "")
        cardsView.cardsCount = demahModels.count
        cardsView.header.showAllButton.addTarget(self, action: #selector(handleShowAllDemahsBtnTap), for: .touchUpInside)
        
        return cardsView
    }()
    
    let user = UserDefaultsManager.user
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainScreenBackgroundColor
        
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateScreen()
    }
    
    // MARK: View Setups
        
    func setupSubviews()  {
        setupWelcomeBadge()
        setupDailyGoalView()
        setupDailyDemahView()
    }
    
    func setupDailyGoalView() {
        view.addSubview(dailyGoalView)
        
        NSLayoutConstraint.activate([
            dailyGoalView.topAnchor.constraint(equalTo: greetingMessageView.bottomAnchor, constant: LayoutConstants.screenHeight * 0.06),
            dailyGoalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dailyGoalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dailyGoalView.heightAnchor.constraint(equalToConstant: itemsViewHeight)
            
        ])
    }
    
    func setupDailyDemahView() {
        view.addSubview(dailyDemahView)
        
        NSLayoutConstraint.activate([
            dailyDemahView.topAnchor.constraint(equalTo: dailyGoalView.bottomAnchor, constant: LayoutConstants.screenHeight * 0.035),
            dailyDemahView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dailyDemahView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dailyDemahView.heightAnchor.constraint(equalToConstant: itemsViewHeight)
            
        ])
    }
    
    func setupWelcomeBadge() {
        view.addSubview(greetingMessageView)
        
        NSLayoutConstraint.activate([
            greetingMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.screenWidth * 0.06),
            greetingMessageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: LayoutConstants.screenHeight * 0.055),
            greetingMessageView.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.03),
            greetingMessageView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    // MARK: Event Handlers
    
    @objc func handleShowAllGoalsBtnTap() {
        navigateToShowAllItemsScreen(withModels: goalModels, title: dailyGoalView.title)
    }
    
    @objc func handleShowAllDemahsBtnTap() {
        navigateToShowAllItemsScreen(withModels: demahModels, title: dailyDemahView.title)
    }
    
    // MARK: Tools
    
    func updateScreen() {
        updateItemModels()
        dailyGoalView.cardsCount = goalModels.count
        dailyDemahView.cardsCount = demahModels.count
    }
    
    func getUpdatedItemsModel() -> ([ItemModel], [ItemModel]) {
        let itemModels = RealmManager.retrieveItems()
        
        var updatedGoalModels: [ItemModel] = []
        var updatedDemahModels: [ItemModel] = []
        
        for item in itemModels {
            let itemDate = Date(timeIntervalSince1970: item.date)
            let itemIsDueToday = Calendar.current.isDateInToday(itemDate)
            
            guard itemIsDueToday && !item.is_completed else { continue }
            
            if item.type == 3 {
                updatedGoalModels.append(item)
            } else if item.type == 1 {
                updatedDemahModels.append(item)
            }
        }
        
        return (updatedGoalModels, updatedDemahModels)
    }
    
    func updateItemModels() {
        let (updatedGoalModels, updatedDemahModels) = getUpdatedItemsModel()
        
        goalModels = updatedGoalModels
        demahModels = updatedDemahModels
    }
    
    func getHour() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        formatter.amSymbol = "Am"
        formatter.pmSymbol = "Pm"
        let timeFromDate = formatter.string(from: Date())
        return timeFromDate
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

extension HomeScreenVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionView == dailyDemahView.cardsCollectionView ? demahModels.count : goalModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardsReuseIdentifier, for: indexPath) as! ItemCardCell
        
        let viewModels = collectionView == dailyDemahView.cardsCollectionView ? demahModels : goalModels
        
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
        self.cardPopup.show()
        cardPopup.viewModel = cell.cardView
    }
    
}
