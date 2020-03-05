//
//  String+Extension.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 12.02.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import UIKit


extension String {
  
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }

        guard let characterSpacing = characterSpacing else {return attributedString}

        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
  
  func floatValue() -> Float {
    
    return (self as NSString).floatValue
  }
  
  
  
}


extension String.StringInterpolation {
  
  
  mutating func appendInterpolation(floatTwo value: Float) {
    let result = String(format: "%0.2f", value)
    appendLiteral(result)
  }
    
    mutating func appendInterpolation(spell value: Int) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        
        if let result = formatter.string(from: value as NSNumber) {
            appendLiteral(result)
        }
    }
    
    mutating func appendInterpolation(dateFormat date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        
        let result = formatter.string(from: date)
        appendLiteral(result)
    }
    
}
