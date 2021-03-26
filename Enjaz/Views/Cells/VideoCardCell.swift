import UIKit

class VideoCardCell: DraftCardCell {
    var viewModel: VideoModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            self.thumbnail.image = viewModel.thumbnail
            self.draftMetaDataContainer.categoryLabel.text = viewModel.category
            self.draftMetaDataContainer.titleLabel.text = viewModel.title
            self.draftMetaDataContainer.dateLabel.text = DateAndTimeTools.getReadableDate(from: viewModel.date, withFormat: "dd/MM/yyyy", calendarIdentifier: .gregorian)
        }
    }
    
    let playBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let playIcon = UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate).withTintColor(.white)
        
        button.setImage(playIcon, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.backgroundColor = .accentColor
        button.tintColor = .white
        
        return button
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        setupPlayBtn()
    }
    
    func setupPlayBtn() {
        thumbnail.addSubview(playBtn)
        
        let size: CGFloat = 25
        playBtn.layer.cornerRadius = size / 2
        
        playBtn.center()
        NSLayoutConstraint.activate([
            playBtn.heightAnchor.constraint(equalToConstant: size),
            playBtn.widthAnchor.constraint(equalToConstant: size),
        ])
    }
}
