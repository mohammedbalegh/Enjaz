import UIKit

class LifeTreeVC: UIViewController, UITextFieldDelegate {
    
    var trees: [TreeModel] = []
    let popup = WateringTreePopup()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .gray
        pageControl.semanticContentAttribute = .forceLeftToRight
        pageControl.currentPageIndicatorTintColor = .accent
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
        pageControl.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    let treeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.register(TreeCollectionViewCell.self, forCellWithReuseIdentifier: "treeCell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let wateringBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "wateringCanBtn"), for: .normal)
        button.addTarget(self, action: #selector(wateringBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        setupWateringBtn()
        setupTreeCollectionView()
        setupPageControl()
        treeCollectionView.delegate = self
        treeCollectionView.dataSource = self
        view.backgroundColor = .background
        title = "Life Tree".localized
    }
    
    func setupWateringBtn() {
        view.addSubview(wateringBtn)
        
        NSLayoutConstraint.activate([
            wateringBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            wateringBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            wateringBtn.widthAnchor.constraint(equalToConstant: 80),
            wateringBtn.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func setupTreeCollectionView() {
        view.addSubview(treeCollectionView)
        
        NSLayoutConstraint.activate([
            treeCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            treeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            treeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            treeCollectionView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func setupPageControl() {
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: treeCollectionView.bottomAnchor, constant: 20),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupPageControl(number pages: Int) {
        pageControl.numberOfPages = pages
        
        if pages < 2 {
            pageControl.isHidden = true
        } else {
            pageControl.isHidden = false
        }
    }
    
    
    @objc func wateringBtnTapped() {
        popup.presentAsConfirmationAlert(
            title: "Are sure you want to sign out?".localized,
            message: "",
            confirmationBtnTitle: "Water".localized, confirmationBtnStyle: .normal)
        {
            if RealmManager.treeStages()?.count == 29 {
                self.createTree(id: RealmManager.retrieveTrees().count)
            } else {
                self.waterTree()
            }
            DispatchQueue.main.async {
                self.treeCollectionView.reloadData()
            }
            self.popup.textField.text = ""
            self.trees = RealmManager.retrieveTrees()
            self.popup.dismiss(animated: true)
        }
    }
    
    func waterTree() {
        let stage = TreeStageModel()
        stage.message = popup.textField.text ?? ""
        stage.stage = RealmManager.treeStages()?.count ?? 0
        RealmManager.waterTree(stage)
    }
    
    
    func createTree(id: Int) {
        let defaultTree = TreeModel()
        defaultTree.id = id
        RealmManager.saveTree(defaultTree)
    }

}

extension LifeTreeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if RealmManager.treesCount == 0 {
            createTree(id: 0)
        }
        trees = RealmManager.retrieveTrees()
        setupPageControl(number: trees.count)
        return trees.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "treeCell", for: indexPath) as! TreeCollectionViewCell
    
        let stage = trees[indexPath.row].stages.count
        
        cell.treeImage.image = UIImage(named: "stage\(stage)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width), height: (collectionView.frame.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tableViewVC = TreeAchievementsVC()
        let navController = UINavigationController(rootViewController: tableViewVC)
        tableViewVC.modalPresentationStyle = .fullScreen
        tableViewVC.id = trees[indexPath.row].id
        self.present(navController, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
}
