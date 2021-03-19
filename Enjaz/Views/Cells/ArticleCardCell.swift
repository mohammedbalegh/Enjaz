import UIKit

class ArticleCardCell: DraftCardCell {
    var viewModel: ArticleModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            self.thumbnail.image = viewModel.thumbnail
            self.draftMetaDataContainer.categoryLabel.text = viewModel.category
            self.draftMetaDataContainer.titleLabel.text = viewModel.title
            self.draftMetaDataContainer.dateLabel.text = DateAndTimeTools.getReadableDate(from: viewModel.date, withFormat: "dd/mm/yyyy", calendarIdentifier: .gregorian)
        }
    }
}
