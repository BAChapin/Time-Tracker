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
    
    var endOfDay: Date {
        let sod = self.startOfDay.timeIntervalSince1970
        let eod = sod + TimeInterval.secondsInDay - 1
        return Date(timeIntervalSince1970: eod)
    }
    
    var startOfNextDay: Date {
        let sod = self.startOfDay.timeIntervalSince1970
        let nd = sod + TimeInterval.secondsInDay
        return Date(timeIntervalSince1970: nd)
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
    
    func isInDate(_ timeInterval: TimeInterval) -> Bool {
        let startOfDay = self.startOfDay.timeIntervalSince1970
        let endOfDay = startOfDay + TimeInterval.secondsInDay
        return startOfDay <= timeInterval && timeInterval < endOfDay
    }
    
    static func dateRange(from d1: Date, to d2: Date) -> [Date] {
        var returnDates: [Date] = []
        var tempDate = d1.startOfDay
        
        while tempDate <= d2 {
            returnDates.append(tempDate)
            tempDate = (Calendar.current.date(byAdding: .day, value: 1, to: tempDate) ?? d2).startOfDay
        }
        return returnDates
    }
}
