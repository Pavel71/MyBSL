//
//  UIViewController+Extension.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func showAlertController(title: String, message: String) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
    
    alertController.addAction(okAction)
//    alertController.addAction(cancelAction)
    present(alertController, animated: true, completion: nil)
    
  }
  
}
