import UIKit
import Lottie

class Toast: UIView {
        
    static let shared = Toast()
    
    static let width = LayoutConstants.screenWidth * 0.6
    static let height = width * 1.05
    
    var animationView: AnimationView = {
        var animationView = AnimationView(name: "success-animation")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        return animationView
    }()
    
    var titleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let fontSize: CGFloat = max(20, LayoutConstants.screenWidth * 0.055)
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = .systemGray4
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private func setup() {
        guard let superview = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        backgroundColor = UIColor(white: 0.35, alpha: 0.95)
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            widthAnchor.constraint(equalToConstant: Toast.width),
            heightAnchor.constraint(equalToConstant: Toast.height),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSuccessImage()
        setupTitleLabel()
    }
        
    func setupSuccessImage() {
        addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: topAnchor),
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
            animationView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
        ])
        
        animationView.animationSpeed = 3
        animationView.play(fromFrame: 30, toFrame: 150, loopMode: .playOnce) {_ in
            Vibration.success.vibrate()
        }
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.9),
        ])
    }
    
    func show(withTitle title: String, andDuration duration: TimeInterval = 2.5) {
        titleLabel.text = title
        show(withDuration: duration)
    }
    
    private func show(withDuration duration: TimeInterval) {
        guard superview == nil else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.hide()
        }
        
        alpha = 0
        isUserInteractionEnabled = false
        
        let window = UIApplication.shared.windows[0]
        window.addSubview(self);
        setup()
        animateToastContainerInAndOut()
    }
    
    func hide() {
        guard superview != nil else { return }
        
        animateToastContainerInAndOut() {_ in
            self.removeFromSuperview()
        }
    }
    
    func animateToastContainerInAndOut(onAnimationComplete: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.alpha = self.alpha == 0 ? 1 : 0
            },
            completion: onAnimationComplete
        )
    }
    
}
