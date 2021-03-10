import UIKit

class CardModalVC: UIViewController {
    let header = ModalHeader(frame: .zero)
    
    override var title: String? {
        didSet {
            header.titleLabel.text = title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
    }
    
    
    func setupHeader() {
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        header.dismissButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
    }
    
    @objc func dismissModal() {
        dismiss(animated: true)
    }
}
