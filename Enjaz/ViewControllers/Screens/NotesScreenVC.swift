import UIKit

class NotesScreenVC: UIViewController {
    
    var id: Int = 0
    
    var noteAvatar: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var note = RealmManager.retrieveAspect(id: id)
    
    var noteDescription: UILabel = {
        var label = UILabel()
        label.textColor = .label
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var titleLabel: SelfEvaluationLabel = {
        var label = SelfEvaluationLabel()
        label.textAlignment = .center
        label.textColor = .accentColor
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var editableTextView: EditableTextView = {
        var text = EditableTextView(frame: .zero)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    var submitChangesButton: UIButton = {
        var button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named:"checkButton"), for: .normal)
        button.addTarget(self, action: #selector(submitNoteChanges), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .rootTabBarScreensBackgroundColor
        setup()
        self.hideKeyboardWhenTappedAround()
    }
    
    
    
    func setup() {
        
        title = note.title
        noteAvatar.image = note.image.toImage()
        noteDescription.text = note.aspect_description
        titleLabel.text = " " + note.title + "      "
        editableTextView.inputText = note.aspect_text
        
        
        setupNoteAvatar()
        setupNoteDescription()
        setupTitleLabel()
        setupEditableTextView()
        setupSubmitNoteChanges()
    }
    
    @objc func submitNoteChanges() {
        try! RealmManager.realm.write{
            note.aspect_text = editableTextView.text
        }
        navigationController?.popViewController(animated: true)
    }
    
    func setupSubmitNoteChanges() {
        view.addSubview(submitChangesButton)
        
        let size = LayoutConstants.screenWidth * 0.151
        
        NSLayoutConstraint.activate([
            submitChangesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(LayoutConstants.screenHeight * 0.06)),
            submitChangesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitChangesButton.widthAnchor.constraint(equalToConstant: size),
            submitChangesButton.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    func setupEditableTextView() {
        view.addSubview(editableTextView)
        
        editableTextView.layer.borderWidth = 2
        editableTextView.layer.borderColor = UIColor(hex: 0xB4B4B4).cgColor
        editableTextView.layer.cornerRadius = 5
        
        NSLayoutConstraint.activate([
            editableTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            editableTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editableTextView.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.885),
            editableTextView.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.382)
        ])
    }
    
    func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: noteDescription.bottomAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupNoteDescription() {
        view.addSubview(noteDescription)
        
        NSLayoutConstraint.activate([
            noteDescription.topAnchor.constraint(equalTo: noteAvatar.bottomAnchor, constant: 20),
            noteDescription.centerXAnchor.constraint(equalTo: noteAvatar.centerXAnchor),
            noteDescription.widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.63),
            noteDescription.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.072)
        ])
    }
    
    func setupNoteAvatar() {
        view.addSubview(noteAvatar)
        
        let size = LayoutConstants.screenWidth * 0.334
        
        NSLayoutConstraint.activate([
            noteAvatar.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.14),
            noteAvatar.heightAnchor.constraint(equalToConstant: size),
            noteAvatar.widthAnchor.constraint(equalToConstant: size),
            noteAvatar.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

}
