import UIKit

class OAuthBtnsHorizontalStack: UIStackView {

    var appleOAuthBtn = OAuthBtn(type: .apple)
    var twitterOAuthBtn = OAuthBtn(type: .twitter)
    var googleOAuthBtn = OAuthBtn(type: .google)
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        distribution = .fillEqually
        spacing = 15
        
        addArrangedSubview(appleOAuthBtn)
        addArrangedSubview(twitterOAuthBtn)
        addArrangedSubview(googleOAuthBtn)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
