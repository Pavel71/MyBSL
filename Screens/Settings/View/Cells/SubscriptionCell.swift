//
//  SubscriptionCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 22.07.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


// Ячейка должна отображать сколько осталось времени до окончания подписки + возможность отменить подписку! но это позже

class SubscriptionCell : UITableViewCell {
  
  
  let timeSubscriptionLabel: UILabel = {
    let l = UILabel()
    l.text = "11.09.20"
    return l
  }()
  
  let titleSubsriptLabel : UILabel = {
    let label = UILabel()
    label.text = "Попдписка действительна до: "
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}

// MARK: Set Views
extension SubscriptionCell {
  func setViews() {
    
    let hStack = UIStackView(arrangedSubviews: [
    titleSubsriptLabel,timeSubscriptionLabel
    ])
    hStack.spacing      = 5
    hStack.distribution = .fill
    
    addSubview(hStack)
    hStack.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
  }
}
