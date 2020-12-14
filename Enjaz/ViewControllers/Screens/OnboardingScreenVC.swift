import UIKit

class OnboardingScreenVC: UIViewController {
    
    var contentOffset: CGFloat = 0
    
    let carouselCard = CarouselCard()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .gray
		pageControl.currentPageIndicatorTintColor = .accentColor
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
        pageControl.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    let carouselBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "onBoardingBackgroundImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = .accentColor
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = label.font.withSize(24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(18)
        label.textColor = .gray
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = LayoutConstants.screenWidth
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let carousel: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CarouselCell.self, forCellWithReuseIdentifier: "carouselCell")
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let registerBtn = PrimaryBtn(label: "إنشاء حساب", theme: .white)
    let loginBtn = PrimaryBtn(label: "تسجيل الدخول", theme: .blue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carousel.delegate = self
        carousel.dataSource = self
        view.backgroundColor = .white
        mainLabel.text = carouselCard.mainLabel[0]
        secondaryLabel.text = carouselCard.secondaryLabel[0]
        setupSubviews()
    }
    
    func setupSubviews() {
        setupCarouselBackground()
        setupLogo()
        setupRegisterBtn()
        setupLoginBtn()
        setupCarousel()
        setupSecondaryLabel()
        setupMainLabel()
        setupPageControl()
        timer()
    }
        
    func setupPageControl() {
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: loginBtn.topAnchor, constant: -(LayoutConstants.screenHeight * 0.03)),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 10),
            pageControl.widthAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    func setupCarouselBackground() {
        view.addSubview(carouselBackground)
        carouselBackground.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            carouselBackground.topAnchor.constraint(equalTo: view.topAnchor),
            carouselBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselBackground.heightAnchor.constraint(equalToConstant: (LayoutConstants.screenWidth * 1.23)),
            carouselBackground.bottomAnchor.constraint(equalTo:view.centerYAnchor, constant: (LayoutConstants.screenHeight * 0.06))
        ])
    }
    
    func setupMainLabel() {
        view.addSubview(mainLabel)
        
        NSLayoutConstraint.activate([
            mainLabel.bottomAnchor.constraint(equalTo: secondaryLabel.topAnchor, constant: -(LayoutConstants.screenHeight *  0.012)),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.71),
            mainLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.036)
        ])
    }
    
    func setupSecondaryLabel() {
        view.addSubview(secondaryLabel)
        
        NSLayoutConstraint.activate([
            secondaryLabel.bottomAnchor.constraint(equalTo: loginBtn.topAnchor, constant: -(LayoutConstants.screenHeight *  0.07)),
            secondaryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondaryLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.64),
            secondaryLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.09)
        ])
    }
    
    func setupRegisterBtn() {
        view.addSubview(registerBtn)
        
        NSLayoutConstraint.activate([
            registerBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(LayoutConstants.screenHeight * 0.04)),
            registerBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerBtn.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.57),
            registerBtn.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.05)
        ])
    }
    
    func setupLoginBtn() {
        view.addSubview(loginBtn)
        
        NSLayoutConstraint.activate([
            loginBtn.bottomAnchor.constraint(equalTo: registerBtn.topAnchor, constant: -(LayoutConstants.screenHeight * 0.01)),
            loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginBtn.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.57),
            loginBtn.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.05)
        ])

    }
    
    func setupLogo() {
        view.addSubview(logo)
        let width = (LayoutConstants.screenWidth * 0.22)
        let height = width * 0.9
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (LayoutConstants.screenHeight * 0.045) - 5),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: width),
            logo.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func setupCarousel() {
        view.addSubview(carousel)
        carousel.backgroundColor = UIColor.clear
        carousel.isPagingEnabled = true
        NSLayoutConstraint.activate([
            carousel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
            carousel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carousel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carousel.topAnchor.constraint(equalTo: logo.bottomAnchor)
        ])
    }
    
    func snapToCenter() {
        let centerPoint = view.convert(view.center, to: carousel)
        guard let centerIndexPath = carousel.indexPathForItem(at:centerPoint) else { return }
        carousel.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    func timer() {
        let _ = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(scrollToPoint), userInfo: nil, repeats: true)
    }
    
    @objc func scrollToPoint() {
        DispatchQueue.main.async {
            if self.carousel.contentOffset.x <= 900 {
                self.carousel.setContentOffset(CGPoint(x: self.carousel.contentOffset.x +   self.view.frame.width, y: self.carousel.contentOffset.y), animated:true)
                print(self.carousel.contentOffset.x)
            }
        }
    }

}

extension OnboardingScreenVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width), height: (collectionView.frame.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carouselCell", for: indexPath) as! CarouselCell
        cell.carouselImage.image = carouselCard.carouselImage[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       if scrollView.contentOffset.x < 220{
        mainLabel.text = carouselCard.mainLabel[0]
        secondaryLabel.text = carouselCard.secondaryLabel[0]
       } else if scrollView.contentOffset.x < 640 {
        mainLabel.text = carouselCard.mainLabel[1]
        secondaryLabel.text = carouselCard.secondaryLabel[1]
       } else if scrollView.contentOffset.x < 1060 {
        mainLabel.text = carouselCard.mainLabel[2]
        secondaryLabel.text = carouselCard.secondaryLabel[2]
       } else if scrollView.contentOffset.x > 1060 {
        mainLabel.text = carouselCard.mainLabel[3]
        secondaryLabel.text = carouselCard.secondaryLabel[3]
       }
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
    }
    
}
