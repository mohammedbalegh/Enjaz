import UIKit

class ArticleCardCell: DraftCardCell {
    var viewModel: ArticleModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            self.thumbnail.setImage(from: viewModel.image)
            self.draftMetaDataContainer.categoryLabel.text = viewModel.category
            self.draftMetaDataContainer.titleLabel.text = viewModel.title
            self.draftMetaDataContainer.dateLabel.text = viewModel.date
        }
    }
}
