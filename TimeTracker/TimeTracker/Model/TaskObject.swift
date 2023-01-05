//
//  Task.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/12/22.
//

import Foundation
import FirebaseFirestoreSwift

struct TaskObject: Codable, Hashable, Identifiable {
    
    @DocumentID var id: String?
    let userId: String
    var created: Date = Date()
    var name: String
    var timeGoal: Double?
    var timers: [TimeObject] = []
    
    var weekProgress: TimeInterval {
        return timers.reduce(0) { partialResult, timer in
            return partialResult + timer.totalTime
        }
    }
    var dayProgress: TimeInterval {
        if let todayTimer {
            return todayTimer.totalTime
        }
        return 0
    }
    var isActive: Bool {
        return activeTimer != nil
    }
    var activeTimer: TimeObject? {
        return timers.first(where: { $0.isActive })
    }
    var todayTimer: TimeObject? {
        return timers.first(where: { $0.date >= Date.startOfDay().timeIntervalSince1970 })
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case created
        case name
        case timeGoal
    }
    
    mutating func fetchTimers() async {
        do {
            let sow = Date().startOfWeek.timeIntervalSince1970
            let service = FirebaseFirestoreService()
            let timers = await service.fetchWeeksTimers(for: self.id!)
            switch timers {
            case .success(let timers):
                let weeksTimers = timers.filter { $0.date >= sow }
                if weeksTimers.count > 0 {
                    self.timers = weeksTimers
                } else {
                    let activeTimers = timers.filter { $0.isActive }
                    self.timers = activeTimers
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    mutating func stop() {
        if let activeTimer {
            let currentTime = Date()
            let index = timers.firstIndex(of: activeTimer)
            timers[index!].stop(at: currentTime, true)
            let nextDate = Date(timeIntervalSince1970: timers[index!].date).startOfNextDay
            let newTimers = TimeObject.generateTimers(from: nextDate, to: currentTime, for: self.id!)
            let service = FirebaseFirestoreService()
            service.add(timers: [timers[index!]] + newTimers)
            self.timers.append(contentsOf: newTimers)
        }
    }
    
    mutating func start() {
        if let todayTimer {
            let index = timers.firstIndex(of: todayTimer)
            timers[index!].start()
        } else if let id {
            let timer = TimeObject(taskId: id)
            timer.updateFirebase()
            self.timers.append(timer)
        }
    }
    
}
