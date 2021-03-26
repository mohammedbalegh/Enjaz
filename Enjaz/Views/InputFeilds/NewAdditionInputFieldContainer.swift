import UIKit

class NewAdditionInputFieldContainer: UIView {
    
    var input: (UIView & NewAdditionInputFieldContainerInput)? {
        didSet {
            guard let input = input else { return }
            
            addSubview(input)
            input.translatesAutoresizingMaskIntoConstraints = false
            
            input.constrainEdgesToCorrespondingEdges(of: self, top: 0, leading: 20, bottom: 0, trailing: -25)
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
        layer.borderColor = UIColor.borderColor.cgColor
        layer.borderWidth = 1
        backgroundColor = .white
    }
}
