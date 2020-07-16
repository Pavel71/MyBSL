//
//  RobotView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 28/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit


enum RobotLevels : Int,CaseIterable {
  case first  = 50
  case second = 100
  case third  = 200
  case four   = 300
  case five   = 500
  case six    = 700
  case seven  = 1000
  case eight  = 2000
  case nine   = 4000
  case ten    = 10_000
  
  
  
}

protocol RobotViewModalable {
  var allCompObjCount : Int {get set}
}

// Итак проблема в том что нехочет отрисовывать прогресс!

class RobotView: UIView {
  
  
  
  // MARK: Outlets
  
  
  
  let robotImageView: UIImageView = {
    let iv = UIImageView(image: #imageLiteral(resourceName: "robotlevel50"))
    iv.clipsToBounds = true
    iv.contentMode = .scaleAspectFit
    return iv
  }()
  
  //  lazy private var trackLayer: CAShapeLayer = {
  //    let track = CAShapeLayer()
  //
  //    track.strokeColor = UIColor.lightGray.cgColor
  //    track.lineWidth = 10
  //    track.fillColor = UIColor.clear.cgColor
  //    track.lineCap = CAShapeLayerLineCap.round
  //
  //    self.layer.addSublayer(track)
  ////    self.layer.insertSublayer(track, at: 0)
  //    return track
  //  }()
  //
  //  lazy var shapeLayer: CAShapeLayer = {
  //
  //    let _shapeLayer = CAShapeLayer()
  //
  //    _shapeLayer.fillColor = UIColor.clear.cgColor
  //    _shapeLayer.strokeColor = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1).cgColor
  //    _shapeLayer.lineWidth = 10
  ////    _shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
  //    _shapeLayer.strokeEnd = 0
  //
  //    self.layer.addSublayer(_shapeLayer)
  ////    self.layer.insertSublayer(_shapeLayer, at: 0)
  //
  //    return _shapeLayer
  //
  //  }()
  //
  
  // MARK: Another Layer
  
  var progressLyr = CAShapeLayer()
  var trackLyr    = CAShapeLayer()
  
  var progressClr = #colorLiteral(red: 0.03137254902, green: 0.3294117647, blue: 0.5647058824, alpha: 1) {
    didSet {
      progressLyr.strokeColor = progressClr.cgColor
    }
  }
  var trackClr = UIColor.lightGray {
    didSet {
      trackLyr.strokeColor = trackClr.cgColor
    }
  }
  

  
  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setViews()
    
    
    
    //    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
  }
  
  var robotProgress: CGFloat = 0.0
  
  var didChangeRobotImage: (() -> Void)?
  
  
  //  @objc func handleTap() {
  //
  //
  //    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
  //
  //    shapeLayer.strokeEnd += robotProgress
  //
  //    print(shapeLayer.strokeEnd)
  //
  //    if shapeLayer.strokeEnd > 0.95 {
  //      changeImageView()
  //    }
  //
  //    basicAnimation.duration = 0.3
  //    basicAnimation.fillMode = .forwards
  //    basicAnimation.isRemovedOnCompletion = false
  //
  //    shapeLayer.add(basicAnimation, forKey: "urSoBasic")
  //  }
  
  //
  //  private func changeImageView() {
  //    UIView.animate(withDuration: 0.5) {
  //      self.robotImageView.image = #imageLiteral(resourceName: "robot2")
  //      self.shapeLayer.strokeEnd = 0
  //    }
  //
  ////    didChangeRobotImage!()
  //  }
  
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let radius = (min(bounds.size.width, bounds.size.height) - 10) / 2
    
    self.backgroundColor = UIColor.clear
    self.layer.cornerRadius = self.frame.size.width/2
    
    //
    let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
    
    trackLyr.path = circlePath.cgPath
    trackLyr.fillColor = UIColor.clear.cgColor
    trackLyr.strokeColor = trackClr.cgColor
    trackLyr.lineWidth = 10.0
    trackLyr.strokeEnd = 1.0
    layer.addSublayer(trackLyr)
    progressLyr.path = circlePath.cgPath
    progressLyr.fillColor = UIColor.clear.cgColor
    progressLyr.strokeColor = progressClr.cgColor
    progressLyr.lineWidth = 10.0
    progressLyr.strokeEnd = robotProgress
    layer.addSublayer(progressLyr)
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    
  }
  
  
  
}

// MARK: Set View Model
extension RobotView {
  
  func setViewModel(viewModel: RobotViewModalable) {
    
    
    
    
    let allCompObjCount = viewModel.allCompObjCount
    // теперь надо вычеслить какой уровень у роболта
    
    var robotLevel : RobotLevels = .first
    
    for level in RobotLevels.allCases {
      
      if allCompObjCount < level.rawValue {
        robotLevel = level
        break
      }
    }

    robotProgress = CGFloat(Double(allCompObjCount) / Double(robotLevel.rawValue))
    
    // Также нужно проверить какой уровень и сетить картинку соотвевенно!
    print(robotProgress)
    
    setImageOnRobotLevel(level: robotLevel)
    layoutSubviews()

    
  }
  
  
  private func setImageOnRobotLevel(level: RobotLevels) {
    
    self.robotImageView.image = UIImage(named: "robotlevel" + "\(level.rawValue)")
  }
}

// MARK: Set Up Views

extension RobotView {
  
  private func setViews() {
    
    
    addSubview(robotImageView)
    robotImageView.fillSuperview(padding: .init(top: 40, left: 40, bottom: 40, right: 40))
    
    
  }
}
