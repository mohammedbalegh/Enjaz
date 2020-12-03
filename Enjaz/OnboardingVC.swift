
import UIKit

class OnboardingVC: UIViewController {
    
    var contentOffset: CGFloat = 0
    
    let carouselCard = CarouselCard()
    
    let carouselBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "onBoerdingBackGroundImg")
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
        label.textColor = Colors.mainLabelColor
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
        secondaryLabel.text = carouselCard.secoundaryLabel[0]
        setupSubviews()
    }
    
    func setupSubviews() {
        setupCarouselBackground()
        setupLogo()
        setupRegisterBtn()
        setupLoginBtn()
        setupCarousel()
        setupmainLabel()
        setupSecondaryLabel()
    }
    
    func setupCarouselBackground() {
        view.addSubview(carouselBackground)
        
        self.carousel.isPagingEnabled = true
        
        NSLayoutConstraint.activate([
            carouselBackground.topAnchor.constraint(equalTo:view.topAnchor, constant:(LayoutConstants.screenHeight * 0.02)),
            carouselBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselBackground.heightAnchor.constraint(equalToConstant: (LayoutConstants.screenHeight * 0.57))
        ])
    }
    
    func setupmainLabel() {
        view.addSubview(mainLabel)
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: carouselBackground.bottomAnchor, constant: LayoutConstants.screenHeight *  0.06),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.71),
            mainLabel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.036)
        ])
    }
    
    func setupSecondaryLabel() {
        view.addSubview(secondaryLabel)
        
        NSLayoutConstraint.activate([
            secondaryLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: LayoutConstants.screenHeight *  0.012),
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
        
        NSLayoutConstraint.activate([
            carousel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: (LayoutConstants.screenHeight * 0.015)),
            carousel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carousel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carousel.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.39)
        ])
    }
    
    func snapToCenter() {
        let centerPoint = view.convert(view.center, to: carousel)
        guard let centerIndexPath = carousel.indexPathForItem(at:centerPoint) else { return }
        carousel.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: true)
      }

}

extension OnboardingVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width), height: (collectionView.frame.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carouselCell", for: indexPath) as! CarouselCell
        cell.carouselImage.image = carouselCard.carouselImage[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       if scrollView.contentOffset.x < 220{
        mainLabel.text = carouselCard.mainLabel[0]
        secondaryLabel.text = carouselCard.secoundaryLabel[0]
       } else if scrollView.contentOffset.x < 640 {
        mainLabel.text = carouselCard.mainLabel[1]
        secondaryLabel.text = carouselCard.secoundaryLabel[1]
       } else if scrollView.contentOffset.x > 640 {
        mainLabel.text = carouselCard.mainLabel[2]
        secondaryLabel.text = carouselCard.secoundaryLabel[2]
       }
    }
}
