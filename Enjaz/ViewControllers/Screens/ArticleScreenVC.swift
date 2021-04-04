import UIKit

class ArticleScreenVC: UIViewController {
    // MARK: Properties
    
    var articleModel: ArticleModel! {
        didSet {
            articleHeaderImageView.image = articleModel.header
            draftMetaDataContainer.categoryLabel.text = articleModel.category
            draftMetaDataContainer.titleLabel.text = articleModel.title
            draftMetaDataContainer.dateLabel.text = DateAndTimeTools.getReadableDate(from: articleModel.date, withFormat: "d/M/yyyy", calendarIdentifier: .gregorian)
            articleTextView.text = articleModel.article
        }
    }
    
    let scrollView = UIScrollView()
    
    let articleHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.cornerRadius = 18
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    let draftMetaDataContainer: DraftMetaDataContainer = {
        let draftMetaDataContainer = DraftMetaDataContainer()
        draftMetaDataContainer.translatesAutoresizingMaskIntoConstraints = false
        
        draftMetaDataContainer.categoryLabel.font = .systemFont(ofSize: 16)
        draftMetaDataContainer.titleLabel.font = .systemFont(ofSize: 16)
        draftMetaDataContainer.dateLabel.font = .systemFont(ofSize: 14)
        
        draftMetaDataContainer.categoryLabel.textColor = .systemGray2
        draftMetaDataContainer.titleLabel.textColor = .accentColor
        
        return draftMetaDataContainer
    }()
    
    let articleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textColor = .systemGray
        textView.font = .systemFont(ofSize: 16)
        textView.backgroundColor = .none
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainScreenBackgroundColor
        title = NSLocalizedString("Draft", comment: "")
        
        setupSubViews()
    }
    
    // MARK: View Setups
    
    func setupSubViews() {
        setupScrollView()
        setupArticleHeaderImageView()
        setupArticleMetaDataContainer()
        setupArticleTextView()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.fillSuperView()
    }
    
    func setupArticleHeaderImageView() {
        scrollView.addSubview(articleHeaderImageView)
        
        NSLayoutConstraint.activate([
            articleHeaderImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            articleHeaderImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            articleHeaderImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            articleHeaderImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func setupArticleMetaDataContainer() {
        scrollView.addSubview(draftMetaDataContainer)
        draftMetaDataContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            draftMetaDataContainer.topAnchor.constraint(equalTo: articleHeaderImageView.bottomAnchor, constant: 12),
            draftMetaDataContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            draftMetaDataContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            draftMetaDataContainer.heightAnchor.constraint(equalToConstant: 85),
        ])
    }
    
    func setupArticleTextView() {
        scrollView.addSubview(articleTextView)
        
        NSLayoutConstraint.activate([
            articleTextView.topAnchor.constraint(equalTo: draftMetaDataContainer.bottomAnchor, constant: 15),
            articleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            articleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            articleTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -15),
        ])
    }
    
}
