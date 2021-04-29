import UIKit
import AVFoundation
import MediaPlayer
import AVKit

class DraftScreenVC: UIViewController {
    
    // MARK: Properties
    
    var articleModels: [ArticleModel] = []
    var videoModels: [VideoModel] = []
    var articlesPage = 1
    var videosPage = 1
    
    let cardsReuseIdentifier = "cardCell"
    
    let scrollView = UIScrollView()
    
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
        cardsView.tag = 1
        
        cardsView.title = NSLocalizedString("Most Recent Articles", comment: "")
        cardsView.noCardsMessage = NSLocalizedString("No articles yet", comment: "")
        cardsView.header.cardsCountLabel.isHidden = true
        cardsView.header.showAllButton.addTarget(self, action: #selector(handleShowAllArticlesBtnTap), for: .touchUpInside)
        
        return cardsView
    }()
    
    lazy var videosView: CardsView = {
        let cardsView = CardsView()
        
        cardsView.cardsCollectionView.register(VideoCardCell.self, forCellWithReuseIdentifier: cardsReuseIdentifier)
        cardsView.cardsCollectionView.delegate = self
        cardsView.cardsCollectionView.dataSource = self
        cardsView.tag = 2
        
        cardsView.title = NSLocalizedString("Most Recent Videos", comment: "")
        cardsView.noCardsMessage = NSLocalizedString("No videos yet", comment: "")
        cardsView.header.cardsCountLabel.isHidden = true
        cardsView.header.showAllButton.addTarget(self, action: #selector(handleShowAllVideosBtnTap), for: .touchUpInside)
        
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
        
        view.backgroundColor = .background
        title = NSLocalizedString("Draft", comment: "")
        
        setupSubViews()
    }
        
    // MARK: View Setups
    
    func setupSubViews() {
        setupScrollView()
        setupArticleIconImageView()
        setupCardViewsStack()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.fillSuperView()
    }
    
    func setupArticleIconImageView() {
        scrollView.addSubview(articleIconImageView)
        
        NSLayoutConstraint.activate([
            articleIconImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 25),
            articleIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            articleIconImageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
            articleIconImageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.3),
        ])
    }
    
    func setupCardViewsStack() {
        scrollView.addSubview(cardViewsStack)
        
        NSLayoutConstraint.activate([
            cardViewsStack.topAnchor.constraint(equalTo: articleIconImageView.bottomAnchor, constant: 20),
            cardViewsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardViewsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardViewsStack.heightAnchor.constraint(equalToConstant: 645),
            cardViewsStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    // MARK: Event Handlers
    
    @objc func handleShowAllArticlesBtnTap() {
        navigateToShowAllCardsScreen(withModels: articleModels, title: articlesView.title)
    }
    
    @objc func handleShowAllVideosBtnTap() {
        navigateToShowAllCardsScreen(withModels: videoModels, title: videosView.title)
    }
    
    // MARK: Tools
        
    func updateScreen() {
        updateArticles(page: articlesPage)
        updateVideos(page: videosPage)
    }
    
    func updateArticles(page: Int) {
        articlesView.startIndicatorAnimating()
        articlesView.noCardsLabel.isHidden = true
        
        NetworkingManager.retrieveArticles(in: page) { (articles, error) in
            DispatchQueue.main.async {
                self.articlesView.stopIndicatorAnimating()
                
                guard let articles = articles else {
                    self.articlesView.noCardsLabel.isHidden = false
                    return
                }
                
                self.articleModels += articles
                self.articlesView.cardsCount = articles.count
                self.articlesView.cardsCollectionView.reloadData()
            }
        }
    }
    
    func updateVideos(page: Int) {
        videosView.startIndicatorAnimating()
        videosView.noCardsLabel.isHidden = true
        
        NetworkingManager.retrieveVideos(in: page) { videos, error  in
            DispatchQueue.main.async {
                self.videosView.stopIndicatorAnimating()
                
                guard let videos = videos else {
                    self.videosView.noCardsLabel.isHidden = false
                    return
                }
                
                self.videoModels += videos
                self.videosView.cardsCount = videos.count
                self.videosView.cardsCollectionView.reloadData()
            }
        }
    }
    
    func navigateToArticleScreen(articleModel: ArticleModel) {
        let articleScreen = ArticleScreenVC()
        articleScreen.articleModel = articleModel
        navigationController?.pushViewController(articleScreen, animated: true)
    }
    
    func navigateToShowAllCardsScreen(withModels models: [Any], title: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let showAllCardsScreenVC = models is [ArticleModel]
            ? ShowAllIArticlesScreenVC(collectionViewLayout: layout)
            : ShowAllIVideosScreenVC(collectionViewLayout: layout)
        
        showAllCardsScreenVC.cardModels = models
        showAllCardsScreenVC.title = title
        
        navigationController?.pushViewController(showAllCardsScreenVC, animated: true)
    }
    
    func playVideo(with url: URL) {
        let player = AVPlayer(url: url)
        let playerVC = AVPlayerViewController()
        playerVC.delegate = self
        playerVC.player = player
        self.present(playerVC, animated: true) {
            playerVC.player!.play()
        }
    }
    
}

extension DraftScreenVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, AVPlayerViewControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == articlesView.cardsCollectionView ? articleModels.count : videoModels.count
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
        return CGSize(width: 160, height: collectionView.frame.height * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let offSet = LayoutConstants.screenWidth * 0.035
        return UIEdgeInsets(top: 0, left: offSet, bottom: 0, right: offSet)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == articlesView.cardsCollectionView {
            navigateToArticleScreen(articleModel: articleModels[indexPath.row])
        } else if collectionView == videosView.cardsCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? VideoCardCell
            guard let url = URL(string: cell!.url) else {
                return
            }
            playVideo(with: url)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        let offsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.height
        let width = LayoutConstants.screenWidth
        
        if offsetX > contentWidth - width {
            if scrollView.isEqual(articlesView) {
                articlesPage += 1
                updateArticles(page: articlesPage)
            } else if scrollView.isEqual(videosView) {
                videosPage += 1
                updateVideos(page: videosPage)
            }
            
        }
    }
}
