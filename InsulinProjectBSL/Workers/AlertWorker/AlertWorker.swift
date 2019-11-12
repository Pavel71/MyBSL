//
//  AlertWorker.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


class AlertWorker {
  
 
  
}

// MARK: Bad Compansation

extension AlertWorker {
  
  static func showAlertBadCompansation(
    viewController: UIViewController,
    goToPreviosDinnerComplatition: @escaping ((UIAlertAction) -> Void),
    goToNewDinnerComplatition: @escaping ((UIAlertAction) -> Void)
  ) {
    
    let ac = UIAlertController(title: "Сахар вне нормы!", message: "Давайте исправим предыдущий обед, чтобы ошибок в будущем было меньше. Вы также можете это сделать позже.", preferredStyle: .alert)
    
    let actionPrevDinner = UIAlertAction(title: "Перейти к предыдущему обеду", style: .default, handler: goToPreviosDinnerComplatition)
    let actionNextDinner = UIAlertAction(title: "Продолжить", style: .default, handler: goToNewDinnerComplatition)
    
    ac.addAction(actionPrevDinner)
    ac.addAction(actionNextDinner)
    viewController.present(ac, animated: true, completion: nil)
     
   }
  
}
