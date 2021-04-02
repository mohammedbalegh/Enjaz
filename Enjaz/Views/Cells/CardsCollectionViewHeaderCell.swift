import UIKit

class CardsCollectionViewHeaderCell: UICollectionViewCell {
    let header = CardsViewHeader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHeader()
    }
    
    func setupHeader() {
        contentView.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            header.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            header.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20),
            header.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
