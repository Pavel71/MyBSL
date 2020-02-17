//
//  InsulinPickerView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


class InsulinPickerView: UIPickerView {
  
  let pickerData = [
    ["0.0","10.0","20.0","30.0","40.0"],
    ["0.0","0.5","1.0","1.5","2.0","2.5","3.0","3.5","4.0","4.5","5.0","5.5","6.0","6.5","7.0","7.5","8.0","8.5","9.0","9.5"],
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




// MARK: Picker View Delegate

extension InsulinPickerView: UIPickerViewDelegate,UIPickerViewDataSource {

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
      resultCompTens = Double(pickerData[component][row])!
    case 1:
      resultCompSimple = Double(pickerData[component][row])!
    case 2:
      resultComDrob = Double(pickerData[component][row])!
    default:break
    }
    
    let value = resultCompTens + resultCompSimple + resultComDrob
    passValueFromPickerView!(value)
    
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
