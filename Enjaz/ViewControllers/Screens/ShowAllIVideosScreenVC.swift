import UIKit
import AVFoundation
import MediaPlayer
import AVKit

class ShowAllIVideosScreenVC: ShowAllCardsScreenVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func registerCardCell() {
        self.collectionView!.register(VideoCardCell.self, forCellWithReuseIdentifier: cardsReuseIdentifier)
    }
	
	func playVideo(with url: URL) {
		let player = AVPlayer(url: url)
		let playerVC = AVPlayerViewController()
		playerVC.player = player
		
		self.present(playerVC, animated: true) {
			playerVC.player!.play()
		}
	}
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardsReuseIdentifier, for: indexPath) as! VideoCardCell
            
        cell.viewModel = cardModels[indexPath.row] as? VideoModel
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let videoUrl = (cardModels[indexPath.row] as? VideoModel)?.url, let url = URL(string: videoUrl) {
			playVideo(with: url)
		}
    }

}
