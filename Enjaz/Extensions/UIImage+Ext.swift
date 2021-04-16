import UIKit

extension UIImage {
	convenience init?(source: String) {
		if let decodedData = Data(base64Encoded: source, options: .ignoreUnknownCharacters) {
			self.init(data: decodedData)
		}
		
		self.init(named: source)
	}
	
	static func getImageFrom(_ source: String) -> UIImage? {
		if let decodedData = Data(base64Encoded: source, options: .ignoreUnknownCharacters), source.count > 100 {
			return UIImage(data: decodedData)
		}
		
		return UIImage(named: source)
	}
	
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
	
	func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
		// Determine the scale factor that preserves aspect ratio
		let widthRatio = targetSize.width / size.width
		let heightRatio = targetSize.height / size.height
		
		let scaleFactor = min(widthRatio, heightRatio)
		
		// Compute the new image size that preserves aspect ratio
		let scaledImageSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
		
		// Draw and return the resized UIImage
		let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
		
		let scaledImage = renderer.image { _ in
			self.draw(in: CGRect(origin: .zero, size: scaledImageSize))
		}
		
		return scaledImage
	}
}
