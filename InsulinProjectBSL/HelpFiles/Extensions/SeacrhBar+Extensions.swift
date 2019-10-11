//
//  SeacrhBar+Extensions.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.10.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

extension UISearchBar
{
  func setPlaceholderTextColorTo(color: UIColor)
  {
    let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
    textFieldInsideSearchBar?.textColor = color
    let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
    textFieldInsideSearchBarLabel?.textColor = color
  }
}
