//
//  MainCustomNavBar.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 24/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//
import UIKit


protocol MainNavBarModable {
  
  var titleDate       : Date   {get}
  var lastSevenDays   : [Date] {get}
}

class MainCustomNavBar: UIView {
  
  static let sizeBar: CGRect = .init(x: 0, y: 0, width: 0, height: 60)
  
  
  let titleLabel: UILabel = {
    
    let label = UILabel()
    label.text = "Главный экран"
    label.font = UIFont.systemFont(ofSize: 18)
    label.textAlignment = .center
    return label
  }()
  
  let addNewDinnerButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), for: .normal)
    button.addTarget(self, action: #selector(handleAddNewDinner), for: .touchUpInside)
    return button
  }()
  
  let robotButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "robot32").withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(self, action: #selector(handleRobotMenu), for: .touchUpInside)
    return button
  }()
  
//  var calendarButton: UIButton = {
//    let b = UIButton(type: .system)
//
//    b.setImage(#imageLiteral(resourceName: "calendar").withRenderingMode(.alwaysOriginal), for: .normal)
//    b.addTarget(self, action: #selector(handleCalendarButton), for: .touchUpInside)
//    return b
//  }()
  
  var previosDayButton: UIButton = {
    let b = UIButton(type: .system)
    b.setImage(#imageLiteral(resourceName: "left-arrow"), for: .normal)
    b.addTarget(self, action: #selector(chooseDay), for: .touchUpInside)
    return b
  }()
  
  var nextDayButton: UIButton = {
    let b = UIButton(type: .system)
    b.setImage(#imageLiteral(resourceName: "next"), for: .normal)
    b.addTarget(self, action: #selector(chooseDay), for: .touchUpInside)
    return b
  }()
  
  
  // View Model
  
  var viewModel: MainNavBarVM!
  
  var indexSelectedDay: Int {
    
//    var indexG: Int = 0
//    viewModel.lastSevenDays.enumerated().forEach { (index,date)  in
//      if date.compareDate(with: viewModel.titleDate) {
//        indexG = index
//      }
//    }
    
    var indexG: Int = 0

    for (index,date) in viewModel.lastSevenDays.enumerated() {
      if date.compareDate(with: viewModel.titleDate) {
        indexG = index
      }
    }

    return indexG
  }
  
  // MARK: Clousers
  
  var didTapAddNewDataClouser : EmptyClouser?
  var didTapRobotMenuClouser  : EmptyClouser?
//  var didTapCalendarClouser   : EmptyClouser?
  
  var didTapPreviosDateClouser: ((Date) -> Void)?
  var didTapNextDateClouser   : ((Date) -> Void)?

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    
    backgroundColor = .white
    setUpViews()
    
  }
  

  
  private func setUpViews() {
    
//    let leftStack = UIStackView(arrangedSubviews: [robotButton])
//    leftStack.distribution = .fillEqually
//    leftStack.spacing = 20
    
    
    let centralStack = UIStackView(arrangedSubviews: [
    
    previosDayButton,titleLabel,nextDayButton
    ])
//    centralStack.spacing = 5
    centralStack.distribution = .fill
    
    let stackView = UIStackView(arrangedSubviews: [
    robotButton, centralStack, addNewDinnerButton
    ])
    
    
    stackView.distribution = .equalCentering
    
    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
  }
  
  
  // MARK: Button Signals
  
//  @objc private func handleCalendarButton() {
//    didTapCalendarClouser!()
//  }
  
  // Add New Dinner
  @objc private func handleAddNewDinner() {
    
    didTapAddNewDataClouser!()
  }
  
  // Robot
  @objc private func handleRobotMenu() {
    
    didTapRobotMenuClouser!()
  }
  
  
  
  @objc private func chooseDay(button: UIButton) {
    switch button {
    case nextDayButton:
      
      let nextDate = getNextDate()
      didTapNextDateClouser!(nextDate)
    case previosDayButton:
      let previosDate = getPreviosDate()
      didTapPreviosDateClouser!(previosDate)
    default:break
    }
    
    
    
  }
  
  private func getNextDate() -> Date {
    
    return viewModel.lastSevenDays[indexSelectedDay + 1]
  }
  
  private func getPreviosDate() -> Date {
    return viewModel.lastSevenDays[indexSelectedDay - 1]
  }
  
 
  
  
  override func draw(_ rect: CGRect) {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset  = .init(width: 0, height: 3)
    layer.shadowOpacity = 0.7
    layer.shadowRadius = 2
    
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}



// MARK: Set View Model

extension MainCustomNavBar {
  
  func setViewModel(viewModel: MainNavBarModable) {
    
    self.viewModel = viewModel as? MainNavBarVM
    
    let date = DateWorker.shared.getDayMonthYearWeek(date: viewModel.titleDate)
    titleLabel.text = date
    
    
    if viewModel.lastSevenDays.count > 1 {

      guard let lastElement  = viewModel.lastSevenDays.last else {return}
      guard let firstElement = viewModel.lastSevenDays.first else {return}
      
      previosDayButton.alpha =
        viewModel.titleDate.compareDate(with: firstElement) ? 0 : 1
      nextDayButton.alpha    =
        viewModel.titleDate.compareDate(with: lastElement) ? 0 : 1
      
      
      addNewDinnerButton.isEnabled = viewModel.titleDate.compareDate(with:lastElement)
    } else {
      previosDayButton.alpha = 0
      nextDayButton.alpha    = 0
    }
    
    
    
  }
}


