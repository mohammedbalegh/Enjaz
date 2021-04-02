import UIKit

class ShowAllIArticlesScreenVC: ShowAllCardsScreenVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func registerCardCell() {
        self.collectionView!.register(ArticleCardCell.self, forCellWithReuseIdentifier: cardsReuseIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardsReuseIdentifier, for: indexPath) as! ArticleCardCell
            
        cell.viewModel = cardModels[indexPath.row] as? ArticleModel
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let articleScreen = ArticleScreenVC()
        articleScreen.articleModel = cardModels[indexPath.row] as? ArticleModel
        navigationController?.pushViewController(articleScreen, animated: true)
    }

}
