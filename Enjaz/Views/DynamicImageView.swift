import UIKit

class DynamicImageView: UIImageView {

    var source: String = "" {
        didSet {
            setImage(from: source)
        }
    }
    
    init(source: String? = nil) {
        super.init(frame: .zero)
        if let source = source {
            self.source = source
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(from source: String) {
        if source.isURL {
            guard let url = URL(string: source) else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async() {
                    self.image = UIImage(data: data)
                }
            }
            
            task.resume()
        } else {
            image = UIImage(named: source)
        }
    }

}
