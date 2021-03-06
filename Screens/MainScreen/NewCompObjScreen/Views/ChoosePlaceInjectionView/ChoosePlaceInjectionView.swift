//
//  ChoosePlaceView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 01/10/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit

enum PlaceInjections: String {
  
  case leftArm = "Левая рука"
  case rightArm = "Правая рука"
  case leftLeg = "Левая нога"
  case rightLeg = "Правая нога"
  case stomAche = "Живот"
  
}


class ChoosePlaceInjectionView: UIView {
  
  let defaultButtonColor = UIColor(white: 0.8, alpha: 1)
  
  lazy var leftArmButton = createChooseButton(side: .leftArm)
  lazy var rightArmButton = createChooseButton(side: .rightArm)
  lazy var leftLegButton = createChooseButton(side: .leftLeg)
  lazy var rightLegButton = createChooseButton(side: .rightLeg)
  lazy var stomAcheButton = createChooseButton(side: .stomAche)
  
  let closeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
    return button
  }()
  
  
  func createChooseButton(side: PlaceInjections) -> UIButton {
    
    let button = UIButton(type: .system)
    button.clipsToBounds = true
    button.layer.cornerRadius = 10
    button.setTitle(side.rawValue, for: .normal)
    button.titleLabel?.numberOfLines = 0
    button.titleLabel?.textAlignment = .center
    button.backgroundColor = defaultButtonColor
    
    setTagButton(button: button, side: side)
    
    button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    
    
    return button
    
  }
  
  let titlelabel: UILabel = {
    let label = UILabel()
    label.text = "Выберите место укола!"
    label.font = UIFont.systemFont(ofSize: 20)
    return label
  }()

  
  let armsSize: CGSize = .init(width: 50, height: 150)
  let legsSize: CGSize = .init(width: 60, height: 150)
  let stomachSize: CGSize = .init(width: 120, height: 150)
  
  override init(frame: CGRect){
    super.init(frame: frame)
    
    self.alpha = 0
    
    
    let topStackView = UIStackView(arrangedSubviews: [
    titlelabel,closeButton
    ])
    topStackView.spacing = 10
    topStackView.distribution = .fill

    titlelabel.constrainWidth(constant: 230)
    closeButton.constrainWidth(constant: 30)
    closeButton.constrainHeight(constant: 30)
    

    stomAcheButton.constrainHeight(constant: stomachSize.height)
    stomAcheButton.constrainWidth(constant: stomachSize.width)

    
    let legsStackView = UIStackView(arrangedSubviews: [
      rightLegButton,leftLegButton
      ])
    legsStackView.distribution = .fillEqually
    legsStackView.spacing = 10
    
    leftLegButton.constrainHeight(constant: legsSize.height)

    
    let bodyStackView = UIStackView(arrangedSubviews: [
      stomAcheButton,
      legsStackView
      ])
    bodyStackView.axis = .vertical
    bodyStackView.distribution = .fill
    bodyStackView.spacing = 5
    
    addSubview(bodyStackView)
    bodyStackView.centerInSuperview()
    
    
    
    
    addSubview(leftArmButton)
    leftArmButton.anchor(top: bodyStackView.topAnchor, leading: bodyStackView.trailingAnchor, bottom: nil, trailing: nil,padding: .init(top: 20, left: 10, bottom: 0, right: 0),size: armsSize)


    addSubview(rightArmButton)
    rightArmButton.anchor(top: bodyStackView.topAnchor, leading: nil, bottom: nil, trailing: bodyStackView.leadingAnchor,padding: .init(top: 20, left: 0, bottom: 0, right: 10),size: armsSize)
    
    addSubview(topStackView)
    topStackView.anchor(top: nil, leading: nil, bottom: bodyStackView.topAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 10, right: 0))
    topStackView.centerXInSuperview()
    
    
    
    
  }
  
  
  
  private func setTagButton(button: UIButton, side:PlaceInjections) {
    
    switch side {
      
    case .leftArm:
      button.tag = 0
    case .rightArm:
      button.tag = 1
    case .leftLeg:
      button.tag = 2
    case .rightLeg:
      button.tag = 3
    case .stomAche:
      button.tag = 4
    }
    
  }
  
  var didChooseInjectionsPlace: ((String) -> Void)?
  @objc private func handleButton(button: UIButton) {
    
    [leftArmButton,rightArmButton,leftLegButton,rightLegButton,stomAcheButton].forEach { (button) in
      button.backgroundColor = defaultButtonColor
      button.setTitleColor(#colorLiteral(red: 0.009215689264, green: 0.5889421105, blue: 0.9986923337, alpha: 1), for: .normal)
    }
    
    
    switch button.tag {
    case 0:
      leftArmButton.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
      leftArmButton.setTitleColor(.white, for: .normal)
    case 1:
      rightArmButton.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
      rightArmButton.setTitleColor(.white, for: .normal)
    case 2:
      leftLegButton.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
      leftLegButton.setTitleColor(.white, for: .normal)
    case 3:
      rightLegButton.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
      rightLegButton.setTitleColor(.white, for: .normal)
    case 4:
      stomAcheButton.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1)
      stomAcheButton.setTitleColor(.white, for: .normal)
    default:break
    }
    let title = button.titleLabel?.text ?? ""
    didChooseInjectionsPlace!(title)
    
  }
  
  var didTapCloseButton: EmptyClouser?
  @objc private func handleCloseButton() {
    didTapCloseButton!()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
