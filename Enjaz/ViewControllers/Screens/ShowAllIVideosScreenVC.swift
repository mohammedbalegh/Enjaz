import UIKit

class ShowAllIVideosScreenVC: ShowAllCardsScreenVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func registerCardCell() {
        self.collectionView!.register(VideoCardCell.self, forCellWithReuseIdentifier: cardsReuseIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardsReuseIdentifier, for: indexPath) as! VideoCardCell
            
        cell.viewModel = cardModels[indexPath.row] as? VideoModel
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: implement show video
        print("show video")
    }

}
