import UIKit

class NewAdditionInputFieldContainer: UIView {
    
    var input: UIView? {
        didSet {
            onInputSet()
        }
    }
    
    var fieldName: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        layer.cornerRadius = LayoutConstants.inputHeight / 2
        layer.borderColor = UIColor.init(white: 0.85, alpha: 1).cgColor
        layer.borderWidth = 1
        backgroundColor = .white
    }
    
    func onInputSet() {
        guard let input = input else { return }
        
        addSubview(input)
        input.translatesAutoresizingMaskIntoConstraints = false
        
        input.constrainEdgesToCorrespondingEdges(of: self, top: 0, leading: 20, bottom: 0, trailing: -25)
    }
    
}
