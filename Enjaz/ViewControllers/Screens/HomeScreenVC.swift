import UIKit

class HomeScreenVC: UIViewController {
    
    let taskCardModels: [TaskCardModel] = [
        TaskCardModel(image: #imageLiteral(resourceName: "mosque"), title: "حفظ 5 صفحات من القرآن", type: "ديني", date: "الساعة    03:00", description: "", checkBtnIsHidden: true),
        
        TaskCardModel(image: #imageLiteral(resourceName: "familyIcon"), title: "زيارة جدتي", type: "أجتماعي", date: "الساعة  05:00", description: "", checkBtnIsHidden: true)
    ]
    
    let demahCardModels: [TaskCardModel] = [
        TaskCardModel(image: #imageLiteral(resourceName: "fireworksIcon"), title: "مشاهدة المسلسل", type: "ترفيهي", date: "الساعة 05:00", description: "", checkBtnIsHidden: true),
        TaskCardModel(image: #imageLiteral(resourceName: "fireworksIcon"), title: "مشاهدة المسلسل", type: "ترفيهي", date: "الساعة 05:00", description: "", checkBtnIsHidden: true),
        TaskCardModel(image: #imageLiteral(resourceName: "fireworksIcon"), title: "مشاهدة المسلسل", type: "ترفيهي", date: "الساعة 05:00", description: "", checkBtnIsHidden: true),
        TaskCardModel(image: #imageLiteral(resourceName: "fireworksIcon"), title: "مشاهدة المسلسل", type: "ترفيهي", date: "الساعة 05:00", description: "", checkBtnIsHidden: true)
        
    ]
    
    let cardPopup = CardPopup(frame: .zero)
    let collectionHeight = LayoutConstants.screenHeight * 0.238
    
    lazy var welcomeBadge: WelcomeBadgeView = {
        let view = WelcomeBadgeView()
        let mode = time()
        if mode == "am" {
            view.image.image = #imageLiteral(resourceName: "sunIcon")
            view.welcomeLabel.text = "صباح الخير احمد!"
            view.messageLabel.text = "أطلع على مهام وعادات اليوم"
        } else {
            view.image.image = #imageLiteral(resourceName: "moonIcon")
            view.welcomeLabel.text = "مساء الخير احمد!"
            view.messageLabel.text = "أطلع على المهام المتبقية"
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dailyTaskView: TasksView = {
        let view = TasksView()
        view.collectionTopBar.typeLabel.text = "مهام اليوم"
        view.collectionTopBar.tasksCountLabel.text = "\(self.taskCardModels.count)"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dailyDemahView: TasksView = {
        let view = TasksView()
        view.collectionTopBar.tasksCountLabel.text = "\(self.demahCardModels.count)"
        view.collectionTopBar.typeLabel.text = "ديمة اليوم"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rootTabBarScreensBackgroundColor
        dailyTaskView.cards.delegate = self
        dailyTaskView.cards.dataSource = self
        dailyDemahView.cards.delegate = self
        dailyDemahView.cards.dataSource = self
        setupSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func time() -> String {
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
            welcomeBadge.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(LayoutConstants.screenWidth * 0.053)),
            welcomeBadge.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (LayoutConstants.screenHeight * 0.115)),
            welcomeBadge.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.05),
            welcomeBadge.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.6)
        ])
    }
  
}

extension HomeScreenVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.dailyTaskView.cards {
            return taskCardModels.count
        } else {
            return demahCardModels.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCell
        let cardModels = collectionView == self.dailyTaskView.cards ? taskCardModels  : demahCardModels
        
        cell.viewModel = cardModels[indexPath.row]
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
        self.cardPopup.show(inside: view)
        cardPopup.image.image = cell.image.image
        cardPopup.titleLabel.text = cell.cardInfo.titleLabel.text
        cardPopup.typeLabel.text = cell.cardInfo.typeLabel.text
        cardPopup.timeLabel.text = cell.cardInfo.timeLabel.text

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        cardPopup.blurOverlay.addGestureRecognizer(tap)
    }
    
    @objc func dismissPopup() {
        cardPopup.hide()
    }

}
