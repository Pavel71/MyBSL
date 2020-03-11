//
//  Double+Extensions.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 11.03.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//

import Foundation



extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}


extension Float {
    func roundToDecimal(_ fractionDigits: Int) -> Float {
        let multiplier = pow(10, Float(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
