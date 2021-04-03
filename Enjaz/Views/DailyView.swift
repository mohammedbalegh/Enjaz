import UIKit

class DailyView: UIView {
    
    let carouselCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: ZoomAndSnapFlowLayout())
        cv.register(DailyViewCell.self, forCellWithReuseIdentifier: "dailyViewCell")
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupCarouselCollectionView()
    }
    
    func setupCarouselCollectionView() {
        addSubview(carouselCollectionView)
        
        NSLayoutConstraint.activate([
            carouselCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: LayoutConstants.screenHeight * 0.166),
            carouselCollectionView.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.73),
            carouselCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            carouselCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
}

extension DailyView: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dailyViewCell", for: indexPath) as! DailyViewCell
        return cell
    }
}
