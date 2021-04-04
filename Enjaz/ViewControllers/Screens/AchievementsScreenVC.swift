import UIKit

class AchievementsScreenVC: UIViewController {
    
    var achievementModels: [ItemModel] = [] {
        didSet {
            achievementsCarousel.reloadData()
        }
    }
    
    let noAchievementsLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("No achievements to show", comment: "")
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let achievementsCarousel: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(AchievementsCell.self, forCellWithReuseIdentifier: "achievementsCell")
        cv.decelerationRate = UIScrollView.DecelerationRate.fast
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        achievementsCarousel.delegate = self
        achievementsCarousel.dataSource = self
        
        setupSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateItemModels()
        
        if achievementModels.count == 0 {
            noAchievementsLabel.isHidden = false
        } else {
            noAchievementsLabel.isHidden = true
        }
    }
    
    func setupSubViews() {
        setupAchievementsCarousel()
        setupNoAchievementsLabel()
    }
    
    func setupNoAchievementsLabel() {
        view.addSubview(noAchievementsLabel)
        
        NSLayoutConstraint.activate([
            noAchievementsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noAchievementsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noAchievementsLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.6),
            noAchievementsLabel.heightAnchor.constraint(equalToConstant: 30)
            
        ])
    }
    
    func setupAchievementsCarousel() {
        view.addSubview(achievementsCarousel)
        
        NSLayoutConstraint.activate([
            achievementsCarousel.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.1),
            achievementsCarousel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            achievementsCarousel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            achievementsCarousel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(LayoutConstants.screenHeight * 0.131))
        ])
    }
    
    func updateItemModels() {
        achievementModels = RealmManager.retrieveItems(withFilter: "type == \(ItemType.achievement.id)")
    }
    
    func snapToCenter() {
        let centerPoint = view.convert(view.center, to: achievementsCarousel)
        guard let centerIndexPath = achievementsCarousel.indexPathForItem(at:centerPoint) else { return }
        achievementsCarousel.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: true)
    }

}

extension AchievementsScreenVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievementModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "achievementsCell", for: indexPath) as! AchievementsCell
        cell.viewModel = achievementModels[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: LayoutConstants.screenWidth * 0.777, height: LayoutConstants.screenHeight * 0.564 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: LayoutConstants.screenWidth * 0.111, bottom: 0, right: LayoutConstants.screenWidth * 0.111)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.snapToCenter()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.snapToCenter()
    }

}
