
import UIKit

protocol HourPickerDelegate {
    func didSelectRow(row: Int)
}

class HourPickerView: UIPickerView {

    var timeModel: [HourModel] = [HourModel(hour: 1, period: "am"),HourModel(hour: 2, period: "am"),HourModel(hour: 3, period: "am"),HourModel(hour: 4, period: "am"),HourModel(hour: 5, period: " am"),HourModel(hour: 6, period: "am"),HourModel(hour: 7, period: "am"),HourModel(hour: 8, period: "am"),HourModel(hour: 9, period: "am"),HourModel(hour: 10, period: "am"),HourModel(hour: 11, period: "am"),HourModel(hour: 12, period: "am"),HourModel(hour: 1, period: "pm"),HourModel(hour: 2, period: "pm"),HourModel(hour: 3, period: "pm"),HourModel(hour: 4, period: "pm"),HourModel(hour: 5, period: "pm"),HourModel(hour: 6, period: "pm"),HourModel(hour: 7, period: "pm"),HourModel(hour: 8, period: "pm"),HourModel(hour: 9, period: "pm"),HourModel(hour: 10, period: "pm"),HourModel(hour: 11, period: "pm"),HourModel(hour: 12, period: "pm")
    ]
    
    var hourPickerDelegate: HourPickerDelegate?
    
    let pickerWidth = LayoutConstants.screenHeight * 0.0853
    let pickerHeight = LayoutConstants.screenWidth * 0.104
    
    var selectedTimePickerIndex = 0
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HourPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeModel.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component:Int, reusing view: UIView?) -> UIView {
        
        let view = UIView()
        
        let hour = UILabel(frame: CGRect(x: 0, y: pickerHeight / 2 - 5, width: pickerHeight, height: pickerHeight / 2))
        hour.textAlignment = .center
        hour.text = "\(timeModel[row].hour)"
        
        view.addSubview(hour)
        
        let period = UILabel(frame: CGRect(x: hour.center.x / 2 , y: frame.height / 2 + 2, width: 20, height: 20))
        period.textAlignment = .center
        period.font = period.font.withSize(10)
        period.text = "\(timeModel[row].period)"
        pickerView.subviews[1].backgroundColor = UIColor.clear
        view.addSubview(period)
        
        if pickerView.selectedRow(inComponent: component) == row {
            hour.textColor = .white
            period.textColor = .white
        } else {
            hour.textColor = .darkGray
            period.textColor = .gray
        }
        
        view.transform = CGAffineTransform(rotationAngle: -(90 * (.pi / 180)))
                
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat{
        return pickerHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTimePickerIndex = row
        hourPickerDelegate?.didSelectRow(row: row)
        pickerView.reloadAllComponents()
    }
    
}
