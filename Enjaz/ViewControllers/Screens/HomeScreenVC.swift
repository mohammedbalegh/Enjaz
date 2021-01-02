import UIKit

class HomeScreenVC: UIViewController {
    
    var taskModels: [ItemModel] = [] {
        didSet {
            dailyTaskView.cards.reloadData()
        }
    }
    
    var demahModels: [ItemModel] = [] {
        didSet {
            dailyDemahView.cards.reloadData()
        }
    }
    
    let cardPopup = CardPopup(hideOnOverlayTap: true)
    let collectionHeight = LayoutConstants.screenHeight * 0.27
    
    lazy var welcomeBadge: WelcomeBadgeView = {
        let view = WelcomeBadgeView()
        let mode = getHour()
        let name = user?.name ?? ""
        
        if mode == "am" {
            view.image.image = #imageLiteral(resourceName: "sunIcon")
            view.welcomeLabel.text = "صباح الخير \(name)!"
            view.messageLabel.text = "أطلع على مهام وعادات اليوم"
        } else {
            view.image.image = #imageLiteral(resourceName: "moonIcon")
            view.welcomeLabel.text = "مساء الخير \(name)!"
            view.messageLabel.text = "أطلع على المهام المتبقية"
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dailyTaskView: ItemsView = {
        let view = ItemsView()
        view.collectionTopBar.typeLabel.text = "مهام اليوم"
        view.collectionTopBar.tasksCountLabel.text = "\(taskModels.count)"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dailyDemahView: ItemsView = {
        let view = ItemsView()
        view.collectionTopBar.tasksCountLabel.text = "\(demahModels.count)"
        view.collectionTopBar.typeLabel.text = "ديمة اليوم"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let user = UserDefaultsManager.getUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .rootTabBarScreensBackgroundColor
        
        dailyTaskView.cards.delegate = self
        dailyTaskView.cards.dataSource = self
        
        dailyDemahView.cards.delegate = self
        dailyDemahView.cards.dataSource = self
        
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateScreen()
    }
    
    func updateScreen() {
        updateItemModels()
        dailyTaskView.updateIndicator(with: taskModels.count)
        dailyDemahView.updateIndicator(with: demahModels.count)
    }
    
    func getUpdatedItemsModel() -> ([ItemModel], [ItemModel]) {
        let itemModels = RealmManager.retrieveItems()
        
        var updatedTaskModels: [ItemModel] = []
        var updatedDemahModels: [ItemModel] = []
        
        itemModels.forEach { (itemModel) in
            if itemModel.type == 0 {
                updatedTaskModels.append(itemModel)
            } else if itemModel.type == 1 {
                updatedDemahModels.append(itemModel)
            }
        }
        
        return (updatedTaskModels, updatedDemahModels)
    }
    
    func updateItemModels() {
        let (updatedTaskModels, updatedDemahModels) = getUpdatedItemsModel()
        
        taskModels = updatedTaskModels
        demahModels = updatedDemahModels
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func getHour() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "Pm"
        let timeFromDate = formatter.string(from: Date())
        return timeFromDate
    }
    
    func setupSubviews()  {
        setupWelcomeBadge()
        setupDailyTaskView()
        setupDailyDemahView()
    }
    
    func setupDailyTaskView() {
        view.addSubview(dailyTaskView)
        
        NSLayoutConstraint.activate([
            dailyTaskView.topAnchor.constraint(equalTo: welcomeBadge.bottomAnchor, constant: LayoutConstants.screenHeight * 0.06),
            dailyTaskView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dailyTaskView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dailyTaskView.heightAnchor.constraint(equalToConstant: collectionHeight)
            
        ])
    }
    
    func setupDailyDemahView() {
        view.addSubview(dailyDemahView)
        
        NSLayoutConstraint.activate([
            dailyDemahView.topAnchor.constraint(equalTo: dailyTaskView.bottomAnchor, constant: LayoutConstants.screenHeight * 0.035),
            dailyDemahView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dailyDemahView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dailyDemahView.heightAnchor.constraint(equalToConstant: collectionHeight)
            
        ])
    }
    
    func setupWelcomeBadge() {
        view.addSubview(welcomeBadge)
        
        NSLayoutConstraint.activate([
            welcomeBadge.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.screenWidth * 0.06),
            welcomeBadge.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.toolBarHeight + 30),
            welcomeBadge.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.03),
            welcomeBadge.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.6)
        ])
    }
}

extension HomeScreenVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionView == self.dailyDemahView.cards ? demahModels.count : taskModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCell
        
        let viewModels = collectionView == self.dailyDemahView.cards ? demahModels : taskModels
        
        cell.viewModel = viewModels[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.screenWidth * 0.09
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2.5), height: (collectionView.frame.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let offSet = LayoutConstants.screenWidth * 0.054
        return UIEdgeInsets(top: 0, left: offSet, bottom: 0, right: offSet)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        self.cardPopup.show()
        cardPopup.viewModel = cell.cardView
    }
    
}
