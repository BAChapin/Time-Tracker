//
//  TimeIntervalExtension.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/25/22.
//

import Foundation

extension TimeInterval {
    
    static var secondsInDay: TimeInterval {
        return 86400
    }
    
    var inMinutes: Double {
        return self > 0 ? self / 60 : 0
    }
    
    var inHours: Double {
        return self > 0 ? self / 3600 : 0
    }
    
    func simpleFormat() -> String {
        let hours = floor(self.inHours)
        let minutes = self.inMinutes
        let remainingMinutes = floor(minutes.truncatingRemainder(dividingBy: 60))
        let remainingSeconds = self.truncatingRemainder(dividingBy: 60)
        
        let strHours = String(format: "%02.0f:", floor(hours))
        let strMinutes = String(format: "%02.0f:", remainingMinutes)
        let strSeconds = String(format: "%02.0f", remainingSeconds)
        return "\(hours >= 1 ? strHours : "")\(strMinutes)\(strSeconds)"
    }
}
