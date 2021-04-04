import UIKit

class NewAdditionInputFieldContainerBtn: UIButton, InputField {
    
    var inputText: String? {
        get {
            return title(for: .normal)
        }
        
        set {
            setTitle(newValue, for: .normal)
        }
    }

}
