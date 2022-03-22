import UIKit

class PickerBottomSheetView: BottomSheetView {
    
    let customAccessoryView: CustomAccessoryView = {
        let customAccessoryView = CustomAccessoryView()
        customAccessoryView.translatesAutoresizingMaskIntoConstraints = false
        
        customAccessoryView.cancelBtn.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        
        return customAccessoryView
    }()
    
    let picker: UIPickerView = {
        let picker = UIPickerView(frame: .zero)
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    let selectBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Select".localized, for: .normal)
        button.setTitleColor(.accent, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        
        return button
    }()
	
    override func setup() {
        height = 270
        thumb.isHidden = true
        contentView.layer.cornerRadius = 0
        contentView.layer.shadowOpacity = 0
        overlay.backgroundColor = .clear
        super.setup()
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCustomAccessoryView()
        setupPicker()
        setupSelectBtn()
    }
    
    func setupCustomAccessoryView() {
        contentView.addSubview(customAccessoryView)

        NSLayoutConstraint.activate([
            customAccessoryView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customAccessoryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customAccessoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customAccessoryView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
        
    func setupPicker() {
        contentView.addSubview(picker)
        
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: customAccessoryView.bottomAnchor),
            picker.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.42),
            picker.widthAnchor.constraint(equalTo: contentView.widthAnchor),
        ])
    }
    
    func setupSelectBtn() {
        contentView.addSubview(selectBtn)

        NSLayoutConstraint.activate([
            selectBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectBtn.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 10),
        ])
    }
}
