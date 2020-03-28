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
  
  lazy var calendar: Koyomi =  {
    
    var koyomi = Koyomi(frame: .zero, sectionSpace: 1.5, cellSpace: 0.5, inset: .zero, weekCellHeight: 25)
    
    koyomi.layer.cornerRadius = 20
    koyomi.clipsToBounds      = true
    
    koyomi.circularViewDiameter = 0.2
    //        koyomi.calendarDelegate = self
    koyomi.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    koyomi.weeks = ("Mon", "Tue", "Wed", "Thu", "Fri","Sun", "Sat")
    koyomi.style = .tealBlue
    koyomi.dayPosition   = .center
    koyomi.selectionMode = .single(style: .background)
    koyomi.selectedStyleColor = UIColor(red: 203/255, green: 119/255, blue: 223/255, alpha: 1)
    
    koyomi.isHiddenOtherMonth = true
//    let today = Date()
//    koyomi.select(date: today)
    
//    let firstDayInMonth = Date().startOfMonth()
//
//    koyomi.setDayColor(.gray, of: firstDayInMonth, to: today.dayBefore())
    koyomi.holidayColor = (.black,.black)
    
    
    
    koyomi
      .setDayFont(size: 14)
      .setWeekFont(size: 10)
    return koyomi
  }()
  
  var shouldSelectDays: [Date] = []
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureView()
    calendar.calendarDelegate = self
    setUpView()
  }
  
  private func configureView() {
    

    layer.cornerRadius = 20
    clipsToBounds = true
    
  }
  
  
  
  private func setUpView() {
    
    
    self.addSubview(calendar)
    calendar.fillSuperview()
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
    self.calendar.setDayColor(.gray, of: firstDay, to: lastDay)
    self.calendar.select(date: viewModel.selectDay)
  }
  
}

// MARK: Koyomi Delegate

extension CalendarView: KoyomiDelegate {
  
  
  func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
    
    
    
    print("You Selected: \(date)")
  }
  
  //    func koyomi(_ koyomi: Koyomi, currentDateString dateString: String) {
  //      currentDateLabel.text = dateString
  //    }
  
  @objc(koyomi:shouldSelectDates:to:withPeriodLength:)
  func koyomi(_ koyomi: Koyomi, shouldSelectDates date: Date?, to toDate: Date?, withPeriodLength length: Int) -> Bool {
    
    // Здесь нам нужно полуить даты которые мы можем выбирать в этом месяце!
    // Для этого сюда нам нужно передать viewModel

    return shouldSelectDays.contains(date!) 
    
    
  }
  
}
