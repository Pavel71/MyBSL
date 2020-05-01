//
//  UIViewController+Extension.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 21/08/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit
import JGProgressHUD

extension UIViewController {
  
  func showAlertController(title: String, message: String) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
    
    alertController.addAction(okAction)
//    alertController.addAction(cancelAction)
    present(alertController, animated: true, completion: nil)
    
  }
  
  func showAlert(title: String, message: String) {
    
    let alertControlelr = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    
    alertControlelr.addAction(alertAction)
    present(alertControlelr, animated: true, completion: nil)
  }
  
  
  
  
  func showAlertControllerWithCancel(
    title         : String,
    confirmDelete : ((UIAlertAction) -> Void)?
  ){
    
    // Нужно подумать как бы мне сюда впихнуть CallBack
    
     let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
    
        let deleteAction    = UIAlertAction(title: "Удалить", style: .destructive, handler: confirmDelete)
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        
        alertController.addAction(deleteAction)
        
        alertController.addAction(cancelAction)
    
        present(alertController, animated: true, completion: nil)
  }
  

  
  
  
}

// MARK: HGProgressUd
extension  UIViewController {
  
  func showSuccesMessage(text: String) {
    
    DispatchQueue.main.async {
       let jcg = JGProgressHUD(style: .dark)
         jcg.indicatorView = JGProgressHUDSuccessIndicatorView()
         jcg.detailTextLabel.text = text
         jcg.show(in: self.view)
         jcg.dismiss(afterDelay: 2)
    }

   
  }
  
  func showErrorMessage(text: String) {
     DispatchQueue.main.async {
        let jcg = JGProgressHUD(style: .dark)
        jcg.indicatorView = JGProgressHUDErrorIndicatorView()
        jcg.detailTextLabel.text = text
        jcg.show(in: self.view)
        jcg.dismiss(afterDelay: 2)
        }
  }
  
}
