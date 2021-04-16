import UIKit

protocol ItemImagePickerPopupDelegate {
	func ImagePickerPopup(_ itemImagePickerPopup: ItemImagePickerPopup, didSelectImage imageId: Int)
	func ImagePickerPopup(_ itemImagePickerPopup: ItemImagePickerPopup, didSelectImageSource imageSource: UIImagePickerController.SourceType)
}
