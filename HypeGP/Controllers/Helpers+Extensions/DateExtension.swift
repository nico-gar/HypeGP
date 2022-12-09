//
//  DateExtension.swift
//  HypeGP
//
//  Created by Nicolas Garaycochea on 12/7/22.
//

import Foundation

extension Date {
    func formateDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
        
    }
}
