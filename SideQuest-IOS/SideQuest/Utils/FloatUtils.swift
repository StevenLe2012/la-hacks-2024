//
//  IntUtils.swift
//  SideQuest
//
//  Created by Atlas on 4/20/24.
//

import Foundation

extension Float {
    func asCurrencyString(locale: Locale = Locale.current) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return formatter.string(from: NSNumber(value: self)) ?? "Invalid number"
    }
}
