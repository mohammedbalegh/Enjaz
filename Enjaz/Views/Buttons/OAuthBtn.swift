import UIKit

class OAuthBtn : UIButton {
    
    enum oAuthBtnType {
        case twitter, apple, google
    }
    
    var type : oAuthBtnType?
    
    init(type: oAuthBtnType) {
        super.init(frame: .zero)
        self.type = type
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure() {
        frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
        
        if let type = type {
            switch type {
            case .twitter:
                setBackgroundImage(UIImage(named: "twitterIcon"), for: .normal)
                
            case .apple:
                setBackgroundImage(UIImage(named: "appleIcon"), for: .normal)
                
            case .google:
                setBackgroundImage(UIImage(named: "googleIcon"), for: .normal)
            }
        }
    }
}
