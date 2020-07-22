//
//  YouTubeLinckCell.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 22.07.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit

// Возможно нужно сделать просто Buttonami ссылки с переходом на youtube вк facebok

class SocialLinckCell : UITableViewCell {
  
  
  let youtubeButton: UIButton = {
    let b = UIButton(type: .system)
    b.setImage(#imageLiteral(resourceName: "youtube").withRenderingMode(.alwaysOriginal), for: .normal)
    b.sizeToFit()
    return b
  }()
  
  let vkButton: UIButton = {
    let b = UIButton(type: .system)
    b.setImage(#imageLiteral(resourceName: "vk").withRenderingMode(.alwaysOriginal), for: .normal)
    b.sizeToFit()
    return b
  }()
  
  let fbButton: UIButton = {
    let b = UIButton(type: .system)
    let image = #imageLiteral(resourceName: "facebook-4").withRenderingMode(.alwaysOriginal)
    
    b.setImage(image, for: .normal)
    b.imageView?.contentMode = .scaleAspectFit
    b.imageEdgeInsets = .init(top: 7, left: 5, bottom: 7, right: 5)
    
    return b
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
extension SocialLinckCell {
  
  func setViews() {
    
    let hStack = UIStackView(arrangedSubviews: [
    youtubeButton,vkButton,fbButton
    ])
    
    hStack.distribution = .fillEqually
    addSubview(hStack)
    hStack.fillSuperview()
  }
}
