import UIKit

class HomeScreenVC: UIViewController {
    
    // MARK: Properties
    
    var goalModels: [ItemModel] = [] {
        didSet {
            dailyGoalView.cardsCollectionView.reloadData()
        }
    }
	
	var taskModels: [ItemModel] = [] {
		didSet {
			dailyTaskView.cardsCollectionView.reloadData()
		}
	}
    
    var demahModels: [ItemModel] = [] {
        didSet {
            dailyDemahView.cardsCollectionView.reloadData()
        }
    }
    
    let cardsReuseIdentifier = "cardCell"
    
    let itemCardPopup = ItemCardPopup()
    
	let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
		return scrollView
	}()
	
    lazy var greetingMessageView: GreetingMessageView = {
        let view = GreetingMessageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
		let hour = Date().getDateComponents(forCalendarIdentifier: Calendar.current.identifier).hour ?? 0
        let name = user?.name
		let firstName = String(name?.split(separator: " ").first ?? "")
        
        if hour < 12 {
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
	
	lazy var dailyTaskView: CardsView = {
		let cardsView = CardsView()
		cardsView.translatesAutoresizingMaskIntoConstraints = false
		
		cardsView.cardsCollectionView.register(ItemCardCell.self, forCellWithReuseIdentifier: cardsReuseIdentifier)
		cardsView.cardsCollectionView.delegate = self
		cardsView.cardsCollectionView.dataSource = self
		
		cardsView.title = NSLocalizedString("Today's tasks", comment: "")
		cardsView.noCardsMessage = NSLocalizedString("No tasks today", comment: "")
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
	
	lazy var itemViewsStack: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [dailyGoalView, dailyTaskView, dailyDemahView])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.spacing = 60
		
		return stackView
	}()
    
    let user = UserDefaultsManager.user
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateScreen()
    }
    
    // MARK: View Setups
        
    func setupSubviews()  {
		setupScrollView()
        setupGreetingMessageView()
        setupItemViewsStack()
    }
	
	func setupScrollView() {
		view.addSubview(scrollView)
		
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		])
	}
	
	func setupGreetingMessageView() {
		scrollView.addSubview(greetingMessageView)
		
		NSLayoutConstraint.activate([
			greetingMessageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50),
			greetingMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
			greetingMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			greetingMessageView.heightAnchor.constraint(equalToConstant: 30),
		])
	}
    
    func setupItemViewsStack() {
		scrollView.addSubview(itemViewsStack)
		let height = itemViewsStack.calculateHeightBasedOn(arrangedSubviewHeight: 240)
		
        NSLayoutConstraint.activate([
			itemViewsStack.topAnchor.constraint(equalTo: greetingMessageView.bottomAnchor, constant: 50),
			itemViewsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			itemViewsStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -60),
			itemViewsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			itemViewsStack.heightAnchor.constraint(equalToConstant: height),
        ])
    }
	
    // MARK: Event Handlers
    
    @objc func handleShowAllGoalsBtnTap() {
        navigateToItemsScreen(withModels: goalModels, title: dailyGoalView.title)
    }
	
	@objc func handleShowAllTasksBtnTap() {
		navigateToItemsScreen(withModels: taskModels, title: dailyGoalView.title)
	}
    
    @objc func handleShowAllDemahsBtnTap() {
        navigateToItemsScreen(withModels: demahModels, title: dailyDemahView.title)
    }
    
    // MARK: Tools
    
    func updateScreen() {
        updateItemModels()
        dailyGoalView.cardsCount = goalModels.count
		dailyTaskView.cardsCount = taskModels.count
        dailyDemahView.cardsCount = demahModels.count
    }
    
	func getUpdatedItemsModel() -> ([ItemModel], [ItemModel], [ItemModel]) {
        let itemModels = RealmManager.retrieveItems()
        
        var updatedGoalModels: [ItemModel] = []
		var updatedTaskModels: [ItemModel] = []
        var updatedDemahModels: [ItemModel] = []
        
        for item in itemModels {
            let itemDate = Date(timeIntervalSince1970: item.date)
            let itemIsDueToday = Calendar.current.isDateInToday(itemDate)
            
            guard itemIsDueToday && !item.is_completed else { continue }
            
            if item.type_id == ItemType.goal.id {
                updatedGoalModels.append(item)
			} else if item.type_id == ItemType.task.id {
				updatedTaskModels.append(item)
			} else if item.type_id == ItemType.demah.id {
                updatedDemahModels.append(item)
            }
        }
        
        return (updatedGoalModels, updatedTaskModels, updatedDemahModels)
    }
    
    func updateItemModels() {
        let (updatedGoalModels, updatedTaskModels, updatedDemahModels) = getUpdatedItemsModel()
		
        goalModels = updatedGoalModels
		taskModels = updatedTaskModels
        demahModels = updatedDemahModels
    }
            
    func navigateToItemsScreen(withModels models: [ItemModel], title: String?) {        
        let itemsScreenVC = ItemsScreenVC()
		itemsScreenVC.items = models
		itemsScreenVC.title = title
        
        navigationController?.pushViewController(itemsScreenVC, animated: true)
    }
}

extension HomeScreenVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    
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
        let viewModels = getViewModels(for: collectionView)
        itemCardPopup.itemModels =  [viewModels[indexPath.row]]
		itemCardPopup.itemsUpdateHandler = updateScreen
        itemCardPopup.present(animated: true)
    }
    
    func getViewModels(for collectionView: UICollectionView) -> [ItemModel] {
        switch collectionView {
        case dailyGoalView.cardsCollectionView: return goalModels
		case dailyTaskView.cardsCollectionView: return taskModels
        case dailyDemahView.cardsCollectionView: return demahModels
        default: return []
        }
    }
    
}
