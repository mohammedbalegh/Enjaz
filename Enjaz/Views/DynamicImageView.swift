import UIKit
import ShimmerSwift

let imageCache = NSCache<AnyObject, AnyObject>()

class DynamicImageView: UIImageView {
	
	let shimmeringView: ShimmeringView = {
		let view = ShimmeringView()
		view.layer.cornerRadius = 2
		view.shimmerSpeed = 0.1
		view.shimmerPauseDuration = 0.8
		view.isShimmering = true
		let contentView = UIView()
		contentView.backgroundColor = .lowContrastGray
		view.contentView = contentView
		
		return view
	}()
	
	var source: String? {
		didSet {
			shimmeringView.isShimmering = true
			shimmeringView.isHidden = false
			
			if let source = source, !source.isEmpty {
				setImage(from: source)
			}
		}
	}
	
	override var frame: CGRect {
		didSet {
			layer.cornerRadius = frame.height / 2
			clipsToBounds = true
		}
	}
	
	override var image: UIImage? {
		didSet {
			if image != nil {
				shimmeringView.isShimmering = false
				shimmeringView.isHidden = true
			}
		}
	}
	
	init(source: String? = nil) {
		super.init(frame: .zero)
		self.source = source
		addSubview(shimmeringView)
		shimmeringView.fillSuperView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setImage(from source: String) {
		if !source.isURL {
			if source.isEmpty { return }
			self.image = UIImage.getImageFrom(source)
			return
		}
		
		guard let url = URL(string: source) else { return }
		
		if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
			self.image = imageFromCache
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			guard let data = data, error == nil else { return }
			
			DispatchQueue.main.async() {
				if let image = UIImage(data: data) {
					imageCache.setObject(image, forKey: url as AnyObject)
					self.image = image
				}
			}
		}
		
		task.resume()
	}
	
}
