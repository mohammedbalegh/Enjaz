
import UIKit

class NoteCategoryView: UIView {
    
    var components: [String] = []
    let size = LayoutConstants.screenWidth * 0.03
    
    let customAccessoryView: CustomAccessoryView = {
        let customAccessoryView = CustomAccessoryView()
        customAccessoryView.translatesAutoresizingMaskIntoConstraints = false
        
        customAccessoryView.doneBtn.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        
        return customAccessoryView
    }()
    
    var badge: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "noteIcon-1")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var arrow: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "arrowIcon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var picker: UIPickerView = {
        var picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    var textView: UITextView = {
        var text = UITextView()
        text.text = "تصنيف المفكرة"
        text.textColor = .lowContrastGray
        text.backgroundColor = .clear
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        textView.inputView = picker
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        setupBadge()
        setupArrow()
        setupTextView()
        setupToolBar()
    }
    
    @objc func handleDismissal() {
        
    }
    
    func setupToolBar() {
        picker.addSubview(customAccessoryView)
        
        NSLayoutConstraint.activate([
            picker.heightAnchor.constraint(equalToConstant: 20),
            picker.leftAnchor.constraint(equalTo: self.leftAnchor),
            picker.rightAnchor.constraint(equalTo: self.rightAnchor),
            picker.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
    
    func setupTextView() {
        addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: badge.trailingAnchor),
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: arrow.leadingAnchor)
        ])
    }
    
    func setupArrow() {
        addSubview(arrow)
        
        NSLayoutConstraint.activate([
            arrow.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            arrow.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            arrow.heightAnchor.constraint(equalToConstant: size / 2),
            arrow.widthAnchor.constraint(equalToConstant: size)
        ])
    }
    
    func setupBadge() {
        addSubview(badge)
        
        NSLayoutConstraint.activate([
            badge.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            badge.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            badge.heightAnchor.constraint(equalToConstant: size),
            badge.widthAnchor.constraint(equalToConstant: size)
        ])
    }
}

extension NoteCategoryView {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return components.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return components[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textView.text = components[row]
    }
}
