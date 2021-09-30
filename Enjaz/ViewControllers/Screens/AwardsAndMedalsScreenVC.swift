import UIKit

class AwardsAndMedalsScreenVC: UIViewController {

    let medals = RealmManager.retrieveItemMedals()

    lazy var rewardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(AwardsAndMedalsCell.self, forCellWithReuseIdentifier: "awardsAndsMedalsCell")
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Awards and medals", comment: "")

        view.backgroundColor = .background
        rewardsCollectionView.delegate = self
        rewardsCollectionView.dataSource = self

        setupSubViews()
    }

    func setupSubViews() {
        setupRewardsCollectionView()
    }

    func setupRewardsCollectionView() {
        view.addSubview(rewardsCollectionView)

        let padding = LayoutConstants.screenWidth * 0.03

        NSLayoutConstraint.activate([
            rewardsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            rewardsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            rewardsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            rewardsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])

    }
    
}

extension AwardsAndMedalsScreenVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "awardsAndsMedalsCell", for: indexPath) as! AwardsAndMedalsCell

        cell.medalsViewModel = medals[indexPath.row]
        
        if medals[indexPath.row].earned == true {
            cell.lockView.isHidden = true
        } else {
            cell.lockView.isHidden = false
        }
        
        return cell
    }



    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RealmManager.itemMedalsCount()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2.1), height: (collectionView.frame.height / 3.5))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.screenHeight * 0.0275
    }
    
}

