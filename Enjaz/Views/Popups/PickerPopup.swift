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
		
        button.setTitle(NSLocalizedString("Select", comment: ""), for: .normal)
		button.setTitleColor(.accent, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 18)
		
		return button
	}()
	
	override func setupSubViews() {
		super.setupSubViews()
		setupPicker()
		setupSelectBtn()
	}
	
    override func setupContentView() {
		contentView.backgroundColor = .secondaryBackground
		contentView.layer.cornerRadius = 20
		
		NSLayoutConstraint.activate([
			contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
			contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
			contentView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.28),
			contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
		])
	}
	
	func setupPicker() {
		contentView.addSubview(picker)
		
		NSLayoutConstraint.activate([
			picker.topAnchor.constraint(equalTo: contentView.topAnchor),
			picker.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.78),
			picker.widthAnchor.constraint(equalTo: contentView.widthAnchor),
		])
	}
	
	func setupSelectBtn() {
		contentView.addSubview(selectBtn)

		NSLayoutConstraint.activate([
			selectBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			selectBtn.topAnchor.constraint(equalTo: picker.bottomAnchor),
		])
	}
}
