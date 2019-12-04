//
//  SugarPickerView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 04.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit



class SugarPickerView: UIPickerView {
  
  let pickerData = [
    ["0.0","10.0","20.0","30.0","40.0"],
    ["0.0","1.0","1.5","2.0","2.5","3.0","3.5","4.0","4.5","5.0","5.5","6.0","6.5","7.0","7.5","8.0","8.5","9.0","9.5"],
    ["0.0","0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9"]
  ]
  
  
  var resultCompTens   : Double = 0
  var resultCompSimple : Double = 0
  var resultComDrob    : Double = 0
  
  // Clouser
  var passValueFromPickerView: ((Double) -> Void)?
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    
    self.delegate    = self
    self.dataSource  = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


// Picker View
//let pickerView: UIPickerView = {
//  let pickerView = UIPickerView()
//  pickerView.backgroundColor = .white
//  pickerView.frame = CGRect(x: 0, y: 0, width: 0, height: 250)
//  return pickerView
//}()

// Нужно понимать что дата будет менятся в зависимости от Натсроек! Вообще мне нужно вынести этот сахарный пиккер в 1 сущность так как я буду его использовать в нескольких местах

//let pickerData = [
//  ["0.0","10.0","20.0","30.0","40.0","50.0","60.0","70.0","80.0","90.0","100.0"],
//  ["0.0","1.0","1.5","2.0","2.5","3.0","3.5","4.0","4.5","5.0","5.5","6.0","6.5","7.0","7.5","8.0","8.5","9.0","9.5"],
//  ["0.0","0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9"]
//]



// MARK: Picker View Delegate

extension SugarPickerView: UIPickerViewDelegate,UIPickerViewDataSource {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return pickerData.count
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData[component].count
  }
  
  func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[component][row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    
    switch component {
    case 0:
      resultCompTens = Double(pickerData[component][row]) as! Double
    case 1:
      resultCompSimple = Double(pickerData[component][row]) as! Double
    case 2:
      resultComDrob = Double(pickerData[component][row]) as! Double
    default:break
    }
    
    let value = resultCompTens + resultCompSimple + resultComDrob
    passValueFromPickerView!(value)
//    insulinTextField.text = String(value)
//    // Делаем изменнеие как будто пишем текстом
//    didChangeInsulinFromPickerView!(insulinTextField)
    
  }
  
  func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    switch component {
    case 1:
      return UIScreen.main.bounds.width / 2
    default:break
    }
    return UIScreen.main.bounds.width / 4
  }

}
