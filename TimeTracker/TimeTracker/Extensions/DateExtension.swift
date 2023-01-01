//
//  DateExtension.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/25/22.
//

import Foundation

extension Date {
    var startOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return sunday!
    }
    
    var endOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        let nextWeek = gregorian.date(byAdding: .day, value: 7, to: sunday!)
        return gregorian.date(byAdding: .second, value: -1, to: nextWeek!)!
    }
    
    var startOfDay: Date {
        return Calendar(identifier: .gregorian)
        .startOfDay(for: self)
    }
    
    static func startOfWeek() -> Date {
        let today = Date()
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))
        return sunday!
    }
    
    static func endOfWeek() -> Date {
        let today = Date()
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))
        let nextWeek = gregorian.date(byAdding: .day, value: 7, to: sunday!)
        return gregorian.date(byAdding: .second, value: -1, to: nextWeek!)!
    }
    
    static func startOfDay() -> Date {
        let today = Date()
        let gregorian = Calendar(identifier: .gregorian)
        return gregorian.startOfDay(for: today)
    }
}
