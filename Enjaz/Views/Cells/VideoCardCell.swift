import UIKit

class VideoCardCell: DraftCardCell {
    var viewModel: VideoModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            self.thumbnail.source = viewModel.thumbnail
            url = viewModel.url
            self.draftMetaDataContainer.categoryLabel.text = viewModel.category
            self.draftMetaDataContainer.titleLabel.text = viewModel.title
            self.draftMetaDataContainer.dateLabel.text = viewModel.date
        }
    }
    
    let playBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let playIcon = UIImage(systemName: "play.fill")
        
        button.setImage(playIcon, for: .normal)
		button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.backgroundColor = .accent
        button.tintColor = .white
        
        return button
    }()
    
    var url = ""
    
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
