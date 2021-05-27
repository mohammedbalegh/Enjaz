
import UIKit

protocol HourPickerDelegate {
    func didSelectRow(row: Int)
}

class HourPickerView: UIPickerView {

    var hourModels: [HourModel] = []
    
    var hourPickerDelegate: HourPickerDelegate?
    
    let pickerWidth = LayoutConstants.screenHeight * 0.0853
    let pickerHeight = LayoutConstants.screenWidth * 0.104
    
    var selectedTimePickerIndex: Int {
        return selectedRow(inComponent: 0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        dataSource = self
        
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
        return hourModels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component:Int, reusing view: UIView?) -> UIView {
        
        let view = UIView()
        
        let hour = UILabel(frame: CGRect(x: 0, y: pickerHeight / 2 - 5, width: pickerHeight, height: pickerHeight / 2))
        hour.textAlignment = .center
        hour.text = "\(hourModels[row].hour)"
        
        view.addSubview(hour)
        
        let period = UILabel(frame: CGRect(x: hour.center.x / 2 , y: frame.height / 2 + 2, width: 20, height: 20))
        period.textAlignment = .center
        period.font = period.font.withSize(10)
        period.text = "\(hourModels[row].period)"
        pickerView.subviews[1].backgroundColor = UIColor.clear
        view.addSubview(period)
        
        if pickerView.selectedRow(inComponent: component) == row {
            hour.textColor = .white
            period.textColor = .white
        } else {
            hour.textColor = .highContrastGray
            period.textColor = .systemGray
        }
        
        view.transform = CGAffineTransform(rotationAngle: -(90 * (.pi / 180)))
                
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat{
        return pickerHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        hourPickerDelegate?.didSelectRow(row: row)
        pickerView.reloadAllComponents()
    }
    
}
