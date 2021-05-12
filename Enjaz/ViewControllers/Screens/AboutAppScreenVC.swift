import UIKit

class AboutAppScreenVC: PrivacyPolicyAndAboutAppVC {
	
	let linksView: LinksView = {
		let view = LinksView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let linksViewHeight: CGFloat = 120
	
    override func viewDidLoad() {
        super.viewDidLoad()
		title = NSLocalizedString("About App", comment: "")
		
		textView.text = "Lorem ipusm dolor"
		textViewTopAnchorConstraint.constant = linksViewHeight + 30
    }
	
	override func setupSubviews() {
		super.setupSubviews()
		setupLinksView()
	}
	
	func setupLinksView() {
		scrollView.addSubview(linksView)
		
		NSLayoutConstraint.activate([
			linksView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
			linksView.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.3),
			linksView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			linksView.heightAnchor.constraint(equalToConstant: linksViewHeight)
		])
	}
	
}
