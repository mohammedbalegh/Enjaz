
import UIKit

class ChartSliderView: UISlider {
    
    var category = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, category: String) {
        super.init(frame: frame)
        self.category = category
        addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func sliderValueDidChange(sender:UISlider!) {
        UserDefaults.standard.set(self.value, forKey: "\(category)")
    }
    
}
