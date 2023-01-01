//
//  Entry.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/25/22.
//

import Foundation

struct TimeEntry: Codable, Hashable {
    var startTime: TimeInterval
    var endTime: TimeInterval?
    
    var elapsedTime: TimeInterval {
        return (endTime ?? Date().timeIntervalSince1970) - startTime

    }
    var isActive: Bool {
        return endTime == nil
    }
    
    mutating func stop() {
        endTime = Date().timeIntervalSince1970
    }
}
