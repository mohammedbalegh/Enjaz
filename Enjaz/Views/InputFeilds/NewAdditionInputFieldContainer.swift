import UIKit

class NewAdditionInputFieldContainer: UIView {
    
    var input: UIView? {
        didSet {
            onInputSet()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        layer.cornerRadius = LayoutConstants.inputHeight / 2
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        backgroundColor = .white
    }
    
    func onInputSet() {
        guard let input = input else { return }
        
        addSubview(input)
        input.translatesAutoresizingMaskIntoConstraints = false
        
        if input is EditableTextView {
            input.constrainEdgesToCorrespondingEdges(of: self, top: 20, leading: 20, bottom: 20, trailing: 20)
        } else {
            NSLayoutConstraint.activate([
                input.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                input.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
                input.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
        }
    }
    
}
