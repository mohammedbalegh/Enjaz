import UIKit

class ModalVC: UIViewController {

	let thumb: UIView = {
		let height: CGFloat = 5
		let width: CGFloat = 35
		let xOffset = LayoutConstants.screenWidth/2 - width/2
		let view = UIView(frame: CGRect(x: xOffset, y: 5, width: width, height: height))
		
		view.layer.cornerRadius = height / 2
		view.backgroundColor = .lowContrastGray
		
		return view
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if isPresentedModally {
			navigationController?.navigationBar.addSubview(thumb)
			navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleModalCancelBtnTap))
		}
	}
	
	
	@objc func handleModalCancelBtnTap() {
		dismiss(animated: true)
	}

}
