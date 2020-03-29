//
//  CalendarView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25.03.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit
import Koyomi


protocol CalendarViewModable {
  
  var dates     : [Date] {get} // здесь будут даты которые можно выбрать!
  var selectDay : Date {get} // День который выбран на данный момент!
}


class CalendarView: UIView {
  
  static let sizeView: CGRect = .init(x: 0, y: 0, width:(UIScreen.main.bounds.width - 80), height: 250)
  
  
  // MARK: OUtlets
  lazy var calendar: Koyomi =  {
    
    var koyomi = Koyomi(frame: .zero, sectionSpace: 3, cellSpace: 1.0, inset: .zero, weekCellHeight: 30)
    
    koyomi.layer.cornerRadius = 20
    koyomi.clipsToBounds      = true
    
    koyomi.circularViewDiameter = 0.2
    //        koyomi.calendarDelegate = self
    koyomi.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    koyomi.weeks = ("Mon", "Tue", "Wed", "Thu", "Fri","Sun", "Sat")
    koyomi.style = .standard
    koyomi.dayPosition   = .center
    koyomi.selectionMode = .single(style: .background)
    koyomi.selectedStyleColor = UIColor(red: 203/255, green: 119/255, blue: 223/255, alpha: 1)
    
    koyomi.isHiddenOtherMonth = true
    
    let firstDayInMonth = Date().startOfMonth()
    let lastDayInMonth  = Date().endOfMonth()
//
//    koyomi.setDayColor(.lightGray, of: firstDayInMonth, to: lastDayInMonth)
    koyomi.holidayColor = (.black,.black)
    
    
    
    koyomi
      .setDayFont(size: 14)
      .setWeekFont(size: 10)
    return koyomi
  }()
  
  var closeButton: UIButton = {
    let b = UIButton(type: .system)
    b.setImage(#imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysOriginal), for: .normal)
    b.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
    return b
  }()
  
  //MARK:  CLousers
  var didTapCLoseCalendar : EmptyClouser?
  var didTapDateClouser   : ((Date) -> Void)?
  
  // Private items
  
  private var shouldSelectDays: [Date] = [] {
    
    didSet {shouldSelectDays = shouldSelectDays.map{$0.onlyDate()!}}
  }
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureView()
    calendar.calendarDelegate = self
    setUpView()
  }
  
  // MARK: Configure
  private func configureView() {
    
    layer.borderWidth   = 2
    layer.borderColor   = UIColor.black.cgColor
    
    layer.shadowRadius  = 5
    layer.shadowOffset  = .init(width: 0, height: 5)
    layer.shadowColor   = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    
    layer.shadowRadius  = 3
    
    layer.cornerRadius  = 20
    clipsToBounds       = true
    
  }
  
  // MARK: Close Button
  
  @objc private func handleCloseButton() {
    
    didTapCLoseCalendar!()
  }
  
  
  // MARK: Set Up Views
  private func setUpView() {
    
    
    let stakView = UIStackView(arrangedSubviews: [
    closeButton,
    calendar
    ])
    stakView.axis         = .vertical
    stakView.distribution = .fill
    stakView.spacing      = 8
    
    self.addSubview(stakView)
    stakView.fillSuperview(padding: .init(top: 8, left: 0, bottom: 0, right: 0))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}

// MARK: Set ViewModel

extension CalendarView {
  
  func setViewModel(viewModel: CalendarViewModable) {
    
    
    guard let firstDay = viewModel.dates.first,let lastDay = viewModel.dates.last else {return}
    
    self.shouldSelectDays = viewModel.dates
    self.calendar.select(date: viewModel.selectDay)
    
    if viewModel.dates.count > 1 {
    
      self.calendar.setDayColor(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1), of: firstDay, to: lastDay)
    }
  }
  
}

// MARK: Koyomi Delegate

extension CalendarView: KoyomiDelegate {
  
  
  func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
    
    // Не знаю почему но он берет дату на день позже
    guard let date = date else {return}
    
    didTapDateClouser!(date.dayAfter())
  }
  
  //    func koyomi(_ koyomi: Koyomi, currentDateString dateString: String) {
  //      currentDateLabel.text = dateString
  //    }
  
  @objc(koyomi:shouldSelectDates:to:withPeriodLength:)
  func koyomi(_ koyomi: Koyomi, shouldSelectDates date: Date?, to toDate: Date?, withPeriodLength length: Int) -> Bool {
    
    guard let date = date else {return false}
    
    return shouldSelectDays.contains(date.onlyDate()!)
    
  }
  
}
