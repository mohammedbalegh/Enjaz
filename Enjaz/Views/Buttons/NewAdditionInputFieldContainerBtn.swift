import UIKit

class NewAdditionInputFieldContainerBtn: UIButton, NewAdditionInputFieldContainerInput {
    
    var inputText: String? {
        get {
            return title(for: .normal)
        }
        
        set {
            setTitle(newValue, for: .normal)
        }
    }

}
