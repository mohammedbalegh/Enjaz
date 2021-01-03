
import UIKit

class MajorGoalsScreenVC: UIViewController {
    
    var majors: [MajorGoalsModel] = [MajorGoalsModel(image: "kaabaIcon", title: "الجانب الديني", description: "الاهداف المتعلقة بالإيمان و علاقتك مع الله سبحانه و تعالي"),
    MajorGoalsModel(image: "bookIcon", title: "الجانب العلمي", description: "الاهداف المرتبطة بالعلم و التعلم و القراءة و الدورات و تنمية العقل"), MajorGoalsModel(image: "stethoscopeIcon", title: "الجانب الصحي", description: "الاهداف المرتبطة بصحتك الشخصية و اللياقة البدنية و الصحة النفسية"),
    MajorGoalsModel(image: "kaabaIcon", title: "الجانب الاجتماعي", description: "الاهداف المتعلقة بالإيمان و علاقتك مع الله سبحانه و تعالي"),MajorGoalsModel(image: "kaabaIcon", title: "الجانب المهني", description: "الاهداف المتعلقة بالإيمان و علاقتك مع الله سبحانه و تعالي"),MajorGoalsModel(image: "kaabaIcon", title: "الجانب الشخصي", description: "الاهداف المتعلقة بالإيمان و علاقتك مع الله سبحانه و تعالي"),MajorGoalsModel(image: "kaabaIcon", title: "الجانب المالي", description: "الاهداف المتعلقة بالإيمان و علاقتك مع الله سبحانه و تعالي")]
    
    lazy var majorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MajorGoalsCell.self, forCellWithReuseIdentifier: "majorGoalsCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rootTabBarScreensBackgroundColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        majorsCollectionView.delegate = self
        majorsCollectionView.dataSource = self
        
        setupSubviews()
    }
    
    func setupSubviews() {
        setupMajorsCollectionView()
    }
    
    func setupMajorsCollectionView() {
        view.addSubview(majorsCollectionView)
        
        majorsCollectionView.backgroundColor = .rootTabBarScreensBackgroundColor
        
        NSLayoutConstraint.activate([
            majorsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            majorsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            majorsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            majorsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.225)
        ])
    }
    
}

extension MajorGoalsScreenVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return majors.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
      return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "majorGoalsCell", for: indexPath) as! MajorGoalsCell
        cell.viewModel = majors[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 1.2), height: (collectionView.frame.height / 2.5))
    }
}