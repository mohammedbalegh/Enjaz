import UIKit

class InputFieldContainer: UIView {
    
    var input: (UIView & InputField)? {
        didSet {
            setupSubViews()
        }
    }
    
    var fieldName: String = ""
    var placeHolder: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        layer.cornerRadius = LayoutConstants.inputHeight / 2
        layer.borderColor = UIColor.border.cgColor
        layer.borderWidth = 1
        backgroundColor = .secondaryBackground
    }
    
    func setupSubViews() {
        setupInputView()
    }
    
    func setupInputView() {
        guard let input = input else { return }
        addSubview(input)
        input.translatesAutoresizingMaskIntoConstraints = false
        
        input.constrainEdgesToCorrespondingEdges(of: self, top: 0, leading: 20, bottom: 0, trailing: -25)
    }
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		layer.borderColor = UIColor.border.cgColor
	}
}
