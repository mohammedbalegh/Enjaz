import UIKit

class DraftScreenVC: UIViewController {
    
    // MARK: Properties
    
    var articleModels: [ArticleModel] = []
    var videoModels: [VideoModel] = []
    
    let cardsReuseIdentifier = "cardCell"
    
    let articleIconImageView: UIImageView = {
        let image = UIImage(named: "articleIcon")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var articlesView: CardsView = {
        let cardsView = CardsView()
        
        cardsView.cardsCollectionView.register(ArticleCardCell.self, forCellWithReuseIdentifier: cardsReuseIdentifier)
        cardsView.cardsCollectionView.delegate = self
        cardsView.cardsCollectionView.dataSource = self
        
        cardsView.title = NSLocalizedString("Most Recent Articles", comment: "")
        cardsView.noCardsMessage = NSLocalizedString("No articles yet", comment: "")
        cardsView.header.cardsCountLabel.isHidden = true
        
        return cardsView
    }()
    
    lazy var videosView: CardsView = {
        let cardsView = CardsView()
        
        cardsView.cardsCollectionView.register(VideoCardCell.self, forCellWithReuseIdentifier: cardsReuseIdentifier)
        cardsView.cardsCollectionView.delegate = self
        cardsView.cardsCollectionView.dataSource = self
        
        cardsView.title = NSLocalizedString("Most Recent Videos", comment: "")
        cardsView.noCardsMessage = NSLocalizedString("No videos yet", comment: "")
        cardsView.header.cardsCountLabel.isHidden = true
        
        return cardsView
    }()
    
    lazy var cardViewsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [articlesView, videosView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateScreen()
        
        view.backgroundColor = .white
        title = NSLocalizedString("Draft", comment: "")
        navigationController?.navigationBar.isTranslucent = false
        
        setupSubViews()
    }
    
    // MARK: View Setups
    
    func setupSubViews() {
        setupArticleIconImageView()
        setupCardViewsStack()
    }
    
    func setupArticleIconImageView() {
        view.addSubview(articleIconImageView)
        
        NSLayoutConstraint.activate([
            articleIconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            articleIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            articleIconImageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
            articleIconImageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.3),
        ])
    }
    
    func setupCardViewsStack() {
        view.addSubview(cardViewsStack)
        
        NSLayoutConstraint.activate([
            cardViewsStack.topAnchor.constraint(equalTo: articleIconImageView.bottomAnchor, constant: 20),
            cardViewsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardViewsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardViewsStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.73)
        ])
    }
    
    // MARK: Tools
        
    func updateScreen() {
        updateArticles()
        updateVideos()
    }
    
    func updateArticles() {
        NetworkingManager.retrieveArticles() { articles in
            self.articleModels = articles
            self.articlesView.cardsCount = articles.count
            self.articlesView.cardsCollectionView.reloadData()
        }
    }
    
    func updateVideos() {
        NetworkingManager.retrieveVideos() { videos in
            self.videoModels = videos
            self.videosView.cardsCount = videos.count
            self.videosView.cardsCollectionView.reloadData()
        }
    }
}

extension DraftScreenVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == articlesView ? articleModels.count : videoModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == articlesView.cardsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardsReuseIdentifier, for: indexPath) as! ArticleCardCell
            
            cell.viewModel = articleModels[indexPath.row]
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardsReuseIdentifier, for: indexPath) as! VideoCardCell
        cell.viewModel = videoModels[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.screenWidth * 0.05
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width * 0.38), height: (collectionView.frame.height * 0.8))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let offSet = LayoutConstants.screenWidth * 0.035
        return UIEdgeInsets(top: 0, left: offSet, bottom: 0, right: offSet)
    }
    
}
