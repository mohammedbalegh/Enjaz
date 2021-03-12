import UIKit

class ArticleCardCell: DraftCardCell {
    var viewModel: ArticleModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            self.thumbnail.image = viewModel.thumbnail
            self.categoryLabel.text = viewModel.category
            self.titleLabel.text = viewModel.title
            self.dateLabel.text = DateAndTimeTools.getReadableDate(from: viewModel.date, withFormat: "dd/mm/yyyy", calendarIdentifier: .gregorian)
        }
    }
}
