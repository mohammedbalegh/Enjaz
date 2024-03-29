import UIKit

class PrivacyPolicyScreenVC: PrivacyPolicyAndAboutAppVC {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Privacy Policy".localized
		
		textView.text = UserDefaultsManager.privacyPolicy
		updateScreen()
	}
	
	func updateScreen() {
		NetworkingManager.retrievePrivacyPolicy { (data, error) in
			DispatchQueue.main.async {
				guard error == nil else {
					return
				}
				
				UserDefaultsManager.privacyPolicy = data?.text
				self.textView.text = data?.text
			}
		}
	}
	
}
