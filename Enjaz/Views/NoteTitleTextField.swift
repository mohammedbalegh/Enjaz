

import UIKit

class NoteTitleTextField: UIView {

    var penImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "penIcon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var textField: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = NSLocalizedString("Note title", comment: "")
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        setupPenImage()
        setupTextFiel()
    }
    
    func setupPenImage() {
        addSubview(penImage)
        
        let size = LayoutConstants.screenHeight * 0.015
        
        NSLayoutConstraint.activate([
            penImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            penImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            penImage.widthAnchor.constraint(equalToConstant: size),
            penImage.heightAnchor.constraint(equalToConstant: size)
            
        ])
    }
    
    func setupTextFiel() {
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: penImage.trailingAnchor, constant: 15),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textField.topAnchor.constraint(equalTo: self.topAnchor)
            
        ])
    }
}
