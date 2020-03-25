//
//  CalendarView.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25.03.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit
import Koyomi


class CalendarView: UIView {
  
  static let sizeView: CGRect = .init(x: 0, y: 0, width:(UIScreen.main.bounds.width - 40), height: 300)
  
   lazy var calendar: Koyomi =  {
    
    var koyomi = Koyomi(frame: .zero, sectionSpace: 1.5, cellSpace: 0.5, inset: .zero, weekCellHeight: 25)
    
        koyomi.circularViewDiameter = 0.2
//        koyomi.calendarDelegate = self
        koyomi.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        koyomi.weeks = ("Mon", "Tue", "Wed", "Thu", "Fri","Sun", "Sat")
        koyomi.style = .tealBlue
        koyomi.dayPosition   = .center
        koyomi.selectionMode = .single(style: .background)
        koyomi.selectedStyleColor = UIColor(red: 203/255, green: 119/255, blue: 223/255, alpha: 1)
        
        koyomi.isHiddenOtherMonth = true
        let today = Date()
        koyomi.select(date: today)
        
        let firstDayInMonth = Date().startOfMonth()

        koyomi.setDayColor(.gray, of: firstDayInMonth, to: today.dayBefore())
        koyomi.holidayColor = (.black,.black)
    
        
        
        koyomi
          .setDayFont(size: 14)
          .setWeekFont(size: 10)
      return koyomi
    }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .red
    calendar.calendarDelegate = self
    setUpView()
  }
  
  
  
  private func setUpView() {
    
    
    self.addSubview(calendar)
    calendar.fillSuperview()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
      

      
      
      if date! < Date().dayBefore() {
        return false
      } else {
       return true
      }
      
      
    }
  
}
