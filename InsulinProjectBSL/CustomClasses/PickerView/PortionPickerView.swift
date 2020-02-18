//
//  PortionPickerView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

//
//  InsulinPickerView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


class PortionPickerView: UIPickerView {
  
  let pickerData =  [
    ["0","50","100","150","200","250","300","350","400","450","500","550","600","650","700","750","800","850","900","950","1000"],
    ["0","10","20","30","40","50","60","70","80","90"],
    ["0","1","2","3","4","5","6","7","8","9"]
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

extension PortionPickerView: UIPickerViewDelegate,UIPickerViewDataSource {

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
