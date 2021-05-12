import UIKit

class PrivacyPolicyAndAboutAppVC: UIViewController {
	
	let scrollView = UIScrollView()
	
	let textView: UITextView = {
		let textView = UITextView()
		textView.translatesAutoresizingMaskIntoConstraints = false
		
		textView.isEditable = false
		textView.isScrollEnabled = false
		textView.textColor = .systemGray
		textView.font = .systemFont(ofSize: 16)
		textView.backgroundColor = .none
		
		return textView
	}()
	
	var textViewTopAnchorConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .background
		
		setupSubviews()
	}
	
	func setupSubviews() {
		setupScrollView()
		setupTextView()
	}
	
	func setupScrollView() {
		view.addSubview(scrollView)
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.fillSuperView()
	}
	
	func setupTextView() {
		scrollView.addSubview(textView)
		
		textViewTopAnchorConstraint = textView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15)
		
		NSLayoutConstraint.activate([
			textViewTopAnchorConstraint,
			textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
			textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
			textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -15),
		])
	}
	
}
