
import UIKit

class CardBodyView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .white
        updateMask()
    }
    
    private func updateMask() {
        let center = CGPoint(x: bounds.midX, y: bounds.minY - 15)

        let path = UIBezierPath(rect: bounds)
        path.addArc(withCenter: center, radius: bounds.width / 4, startAngle: 0, endAngle: 2 * .pi, clockwise: true)

        let mask = CAShapeLayer()
        mask.fillRule = .evenOdd
        mask.path = path.cgPath

        layer.mask = mask
    }
}


