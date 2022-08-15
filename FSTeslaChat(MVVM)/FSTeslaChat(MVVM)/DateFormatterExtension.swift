//
//  DateFormatterExtension.swift
//  FSTeslaChat(MVVM)
//
//  Created by Isiah Parra on 6/27/22.
//

import Foundation

extension DateFormatter {
    
    static func short() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }
}
