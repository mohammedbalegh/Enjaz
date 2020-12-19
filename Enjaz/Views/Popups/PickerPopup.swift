import UIKit

class PickerPopup: Popup {
	
	var picker: UIPickerView = {
		let picker = UIPickerView(frame: .zero)
		picker.translatesAutoresizingMaskIntoConstraints = false
		
		return picker
	}()
	var selectBtn: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.setTitle("اختيار", for: .normal)
		button.setTitleColor(.accentColor, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 18)
		
		return button
	}()
	
	override func onPopupContainerShown() {
		setupPopupContainer()
		setupPicker()
		setupSelectBtn()
	}
	
	func setupPopupContainer() {
		popupContainer.backgroundColor = .white
		popupContainer.layer.cornerRadius = 20
		
		NSLayoutConstraint.activate([
			popupContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
			popupContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
			popupContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.28),
			popupContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
		])
	}
	
	func setupPicker() {
		popupContainer.addSubview(picker)
		
		NSLayoutConstraint.activate([
			picker.topAnchor.constraint(equalTo: popupContainer.topAnchor),
			picker.heightAnchor.constraint(equalTo: popupContainer.heightAnchor, multiplier: 0.78),
			picker.widthAnchor.constraint(equalTo: popupContainer.widthAnchor),
		])
	}
	
	func setupSelectBtn() {
		popupContainer.addSubview(selectBtn)

		NSLayoutConstraint.activate([
			selectBtn.centerXAnchor.constraint(equalTo: popupContainer.centerXAnchor),
			selectBtn.topAnchor.constraint(equalTo: picker.bottomAnchor),
		])
	}
}
