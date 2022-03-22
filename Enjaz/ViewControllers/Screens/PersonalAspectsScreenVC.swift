
import UIKit

class PersonalAspectsScreenVC: UIViewController {
    
    var personalAspectsModel: [PersonalAspectsModel] = [] {
        didSet {
            aspectsCollectionView.reloadData()
        }
    }
    
    lazy var aspectsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .background
        collectionView.register(PersonalAspectsCell.self, forCellWithReuseIdentifier: "personalAspectsCell")
        return collectionView
    }()
    
    var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named:"addButton"), for: .normal)
        button.addTarget(self, action: #selector(createNewNote), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Personal Aspects".localized
        
        view.backgroundColor = .background
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateScreen()
    }
    
    func setup() {
        setupAspectsCollectionView()
        setupAddNote()
    }
    
    func getPersonalAspectsModel() -> [PersonalAspectsModel] {
        let aspectsModels = RealmManager.retrievePersonalAspects()
        
        var updatedPersonalAspects: [PersonalAspectsModel] = []
        
        for item in aspectsModels {
            updatedPersonalAspects.append(item)
        }
        return updatedPersonalAspects
    }
    
    @objc func createNewNote() {
        navigationController?.pushViewController(AddNoteScreenVC(), animated: false)
    }
    
    func updateScreen() {
        let updatedPersonalAspects = getPersonalAspectsModel()
        
        personalAspectsModel = updatedPersonalAspects
    }
    
    
    
    func setupAddNote() {
        view.addSubview(addButton)
        
        let size = LayoutConstants.screenWidth * 0.151
        
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(LayoutConstants.screenHeight * 0.06)),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: size),
            addButton.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    func setupAspectsCollectionView() {
        view.addSubview(aspectsCollectionView)
        
        NSLayoutConstraint.activate([
            aspectsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.176),
            aspectsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(LayoutConstants.screenHeight * 0.125)),
            aspectsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.screenWidth * 0.055),
            aspectsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(LayoutConstants.screenWidth * 0.055))
        ])
    }        
        
}


extension PersonalAspectsScreenVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return personalAspectsModel.count
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath) as! PersonalAspectsCell
        let notesScreenVC = NotesScreenVC()

        notesScreenVC.id = cell.id

        self.navigationController?.pushViewController(notesScreenVC, animated: true)

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "personalAspectsCell", for: indexPath) as! PersonalAspectsCell
        
        let viewModels = personalAspectsModel
        
        cell.viewModel = viewModels[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width), height: (collectionView.frame.height / 6))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.screenHeight * 0.0204
    }
    
    
}
