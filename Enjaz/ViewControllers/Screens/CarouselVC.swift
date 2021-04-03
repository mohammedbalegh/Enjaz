import UIKit

class CarouselVC: UIViewController {
    
    let carouselView: DailyView = {
        let view = DailyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        view.backgroundColor = .mainScreenBackgroundColor
    }
    
    func setupCollectionView() {
        view.addSubview(carouselView)
        
        NSLayoutConstraint.activate([
            carouselView.topAnchor.constraint(equalTo:view.topAnchor),
            carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}
