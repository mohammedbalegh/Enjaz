import UIKit

class KeyboardHandlingBaseViewController: UIViewController {
    
    let keyboardPlaceHolderView = UIView()
    
    private var keyboardHeightConstraint: NSLayoutConstraint!
    private var firstResponderGlobalFrame: CGRect?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToNotification(UIResponder.keyboardWillChangeFrameNotification, selector: #selector(keyboardWillShowOrHide))
                
        setupKeyboardDismisserGestureRecognizer() 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardPlaceHolderView()
    }
    
    private func setupKeyboardPlaceHolderView() {
        view.addSubview(keyboardPlaceHolderView)
        keyboardPlaceHolderView.translatesAutoresizingMaskIntoConstraints = false
        
        keyboardHeightConstraint = keyboardPlaceHolderView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            keyboardPlaceHolderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardPlaceHolderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            keyboardPlaceHolderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardHeightConstraint,
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
}


private extension KeyboardHandlingBaseViewController {
    
    func setupKeyboardDismisserGestureRecognizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShowOrHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if let firstResponder = view.firstResponder {
            firstResponderGlobalFrame = firstResponder.globalFrame
        }
                        
        guard let firstResponderGlobalFrame = firstResponderGlobalFrame else { return }
        
        let padding = firstResponderGlobalFrame.height > 80 ? 50 : firstResponderGlobalFrame.height + 35
        
        let firstResponderMaxYWithPadding = firstResponderGlobalFrame.maxY + padding + (keyboardHeightConstraint?.constant ?? 0)
                
        if endFrameY >= firstResponderMaxYWithPadding {
            self.keyboardHeightConstraint?.constant = 0.0
        } else {
            self.keyboardHeightConstraint?.constant = firstResponderMaxYWithPadding - endFrameY
        }
        
        UIView.animate(
            withDuration: max(duration, 0.3),
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.view.layoutIfNeeded() },
            completion: nil)
    }
    
}
