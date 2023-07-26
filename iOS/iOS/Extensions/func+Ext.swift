//
//  func+Ext.swift
//  iOS
//
//  Created by 박다미 on 2023/07/26.
//

import Foundation

extension NumberFormatter {
    static func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
}
