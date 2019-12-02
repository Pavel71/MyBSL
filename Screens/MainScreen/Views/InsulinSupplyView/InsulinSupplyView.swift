//
//  InsulinSupplyView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 02.12.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit



protocol InsulinSupplyViewModable {
  
  var insulinSupply: Float {get}
  
}


class InsulinSupplyView: UIView {
  
  
  
  let progressView: UIProgressView = {
    
    let pv = UIProgressView()
    pv.progress = 1
    pv.layer.cornerRadius = 5
    pv.clipsToBounds = true
    pv.trackTintColor = .green
//    pv.tintColor = .orange
    
    return pv
  }()
  
  var progressValue: Float = 1.0
  
  let reloadButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "continuous").withRenderingMode(.alwaysTemplate), for: .normal)
    button.addTarget(self, action: #selector(hadnleReloadProgressButton), for: .touchUpInside)
    return button
  }()
  
  let showSupplyButton: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(handleShowSupply), for: .touchUpInside)
    return button
  }()
  
  
  // CLousers
  
  var passSiganlLowSupplyLevel  : EmptyClouser?
  var passSignalShowSupplyLevel : EmptyClouser?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let progressContainer = UIView()
    
    progressContainer.addSubview(progressView)
    progressView.fillSuperview(padding: .init(top: 10, left: 0, bottom: 10, right: 0))
    
    progressContainer.addSubview(showSupplyButton)
    showSupplyButton.fillSuperview()
    
    
    let stackView = UIStackView(arrangedSubviews: [
    progressContainer,reloadButton
    ])
//    progressView.constrainHeight(constant: 3)
    reloadButton.constrainWidth(constant: 30)
    reloadButton.constrainHeight(constant: 30)
    
    stackView.spacing = 5

    
    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 0, left: 10, bottom: 0, right: 10))
    
  }
  
  private func setViewModel(viewModel:InsulinSupplyViewModable) {
    progressValue = viewModel.insulinSupply
    setTrackColor()
    setProgress()
  }
  

  
  
  // Reload Button handler
  @objc private func hadnleReloadProgressButton(button: UIButton) {
//    setProgress(insulinDelete: 0.1)
    // Show View With textField Than User can set Supply and push ok
  }
  
  // Show Supply Button Handler
  
  @objc private func handleShowSupply() {
    passSignalShowSupplyLevel!()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


// MARK: Work with Progress View

extension InsulinSupplyView {
  
  // Set Color
  private func setTrackColor() {
    
    if progressValue < 0.2   {
      progressView.trackTintColor = .red
    } else if progressValue < 0.4 {
      progressView.trackTintColor = .yellow
    } else {
      progressView.trackTintColor = .green
    }
    
    
  }
  
  // Set Progress
  private func setProgress() {
    
    // Возможно сюда я уже буду присдывлать цифру по факту и сетить ее с обновлением viewModel! Но если что это я подрпавлю!
    
//    progressValue = progressView.progress - insulinDelete
    progressView.setProgress(progressValue, animated: true)
    setTrackColor()
    showAlertThanSupplyLow()
  }
  
  private func showAlertThanSupplyLow() {
    if progressValue < 0.1 {
      passSiganlLowSupplyLevel!()
    }
  }
  
}
