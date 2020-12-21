<<<<<<< HEAD
=======

>>>>>>> origin/main
import UIKit

class SetDateAndTimeScreenVC: UIViewController {
    
    var dateModel: [HourModel] = [HourModel(hour: 1, period: "am"),HourModel(hour: 2, period: "am"),HourModel(hour: 3, period: "am"),HourModel(hour: 4, period: "am"),HourModel(hour: 5, period: " am"),HourModel(hour: 6, period: "am"),HourModel(hour: 7, period: "am"),HourModel(hour: 8, period: "am"),HourModel(hour: 9, period: " am"),HourModel(hour: 10, period: "am"),HourModel(hour: 11, period: "am"),HourModel(hour: 12, period: "am"),HourModel(hour: 1, period: "pm"),HourModel(hour: 2, period: "pm"),HourModel(hour: 3, period: "pm"),HourModel(hour: 4, period: "pm"),HourModel(hour: 5, period: "pm"),HourModel(hour: 6, period: "pm"),HourModel(hour: 7, period: "pm"),HourModel(hour: 8, period: "pm"),HourModel(hour: 9, period: "pm"),HourModel(hour: 10, period: "pm"),HourModel(hour: 11, period: "pm"),HourModel(hour: 12, period: "pm")
    ]
    
    let cornerRadius = (LayoutConstants.screenWidth * 0.86) * 0.186
    let pickerWidth = LayoutConstants.screenHeight * 0.0853
    let pickerHeight = LayoutConstants.screenWidth * 0.104
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "التاريخ و الوقت"
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.textColor = .accentColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("الغاء", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.accentColor, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("حفظ", for: .normal)
        button.layer.cornerRadius = cornerRadius / 2
        button.titleLabel?.font = button.titleLabel?.font.withSize(25)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.2
        button.backgroundColor = .accentColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var hourPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.transform = CGAffineTransform(rotationAngle: (90  * (.pi/180)))
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var indicator: UIView = {
        let view = UILabel()
        view.layer.cornerRadius = pickerHeight / 2
        view.clipsToBounds = true
        view.backgroundColor = .accentColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        view.backgroundColor = .white
        
        hourPicker.dataSource = self
        hourPicker.delegate = self
        
        setupSubviews()
    }
    
    func setupSubviews() {
        setupTitleLabel()
        setupDismissButton()
        setupSaveButton()
        setupIndicator()
        setupHourPicker()
    }
    
    func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        let width = LayoutConstants.screenWidth *  0.3
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.025),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: width),
            titleLabel.heightAnchor.constraint(equalToConstant: width * 0.22)
            
        ])
    }
<<<<<<< HEAD
	
	
=======
    
    func setupDismissButton() {
        view.addSubview(dismissButton)
        
        let width = LayoutConstants.screenWidth * 0.106
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: LayoutConstants.screenHeight * 0.04),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.screenWidth * 0.046),
            dismissButton.widthAnchor.constraint(equalToConstant: width),
            dismissButton.heightAnchor.constraint(equalToConstant: width * 0.106)
        ])
    }
    
    func setupSaveButton() {
        view.addSubview(saveButton)
        
        let width = LayoutConstants.screenWidth * 0.86
        
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(LayoutConstants.screenHeight * 0.04)),
            saveButton.widthAnchor.constraint(equalToConstant: width),
            saveButton.heightAnchor.constraint(equalToConstant: width * 0.182)
        ])
    }
    
    func setupHourPicker() {
        view.addSubview(hourPicker)
>>>>>>> origin/main

        NSLayoutConstraint.activate([
            hourPicker.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: LayoutConstants.screenWidth * 0.1),
            hourPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hourPicker.heightAnchor.constraint(equalToConstant: LayoutConstants.screenWidth * 0.87),
            hourPicker.widthAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.085)
        ])
    }
    
    func setupIndicator() {
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -(LayoutConstants.screenWidth * 0.25)),
            indicator.widthAnchor.constraint(equalToConstant: pickerHeight),
            indicator.heightAnchor.constraint(equalToConstant: pickerHeight * 1.7)
        ])
    }
    
}
    
extension SetDateAndTimeScreenVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dateModel.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component:Int, reusing view: UIView?) -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: pickerWidth, height: pickerHeight))
        
        let hour = UILabel(frame: CGRect(x: 0, y: 0, width: pickerWidth, height: pickerHeight / 2))
        hour.text = "\(dateModel[row].hour)"
        hour.textAlignment = .center
        view.addSubview(hour)
        
        let period = UILabel(frame: CGRect(x: view.frame.width / 2 - 10, y: view.frame.height / 2 + 2, width: 20, height: 20))
        period.text = dateModel[row].period
        period.textAlignment = .center
        period.font = period.font.withSize(10)
        view.addSubview(period)
        
        if pickerView.selectedRow(inComponent: component) == row {
            hour.textColor = .white
            period.textColor = .white
        } else {
            hour.textColor = .darkGray
            period.textColor = .gray
        }
        
        pickerView.subviews[1].backgroundColor = UIColor.clear
        
        view.transform = CGAffineTransform(rotationAngle: -(90 * (.pi / 180)))
                
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat{
        return pickerHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
    }
}
