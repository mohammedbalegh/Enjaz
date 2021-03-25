import UIKit

class PrivacyPolicyAndAboutAppScreenVC: UIViewController {
    
    var showAboutAppTopView = false
    
    let aboutAppTopView: AboutTheAppTopView = {
        let view = AboutTheAppTopView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let scrollView = UIScrollView()
    
    let TextView: UITextView = {
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
        
        view.backgroundColor = .rootTabBarScreensBackgroundColor
        
        setupSubView()
    }
    
    func setupSubView() {
        setupScrollView()
        setupAboutAppTopView()
        setupTextView()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.fillSuperView()
    }
    
    func aboutAppTopViewHeight() -> CGFloat {
        if showAboutAppTopView {
            title = NSLocalizedString("About App", comment: "")
            aboutAppTopView.isHidden = false
            return LayoutConstants.screenHeight * 0.15
        } else {
            title = NSLocalizedString("Privacy Policy", comment: "")
            aboutAppTopView.isHidden = true
            return 0
        }
    }
    
    func setupAboutAppTopView() {
        scrollView.addSubview(aboutAppTopView)
        
        NSLayoutConstraint.activate([
            aboutAppTopView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            aboutAppTopView.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.3),
            aboutAppTopView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            aboutAppTopView.heightAnchor.constraint(equalToConstant: aboutAppTopViewHeight())
        ])
    }
    
    func setupTextView() {
        scrollView.addSubview(TextView)
        
        NSLayoutConstraint.activate([
            TextView.topAnchor.constraint(equalTo: aboutAppTopView.bottomAnchor, constant: 15),
            TextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            TextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            TextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -15),
        ])
    }
}
