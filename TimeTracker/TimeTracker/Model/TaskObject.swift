//
//  Task.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/12/22.
//

import Foundation
import SwiftUI
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
    var cellColor: Color {
        return isActive ? Color.blue.opacity(0.3) : (weekProgress.inHours >= timeGoal ?? 0) ? Color.green.opacity(0.3) : Color.gray.opacity(0.3)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case created
        case name
        case timeGoal
    }
    
    init(id: String? = UUID().uuidString, userId: String, created: Date = Date(), name: String, timeGoal: Double? = nil, timers: [TimeObject] = []) {
        self.id = id
        self.userId = userId
        self.created = created
        self.name = name
        self.timeGoal = timeGoal
        self.timers = timers
    }
    
    mutating func edit(name: String? = nil, timeGoal: Double? = nil) {
        self.name = name ?? self.name
        self.timeGoal = timeGoal ?? self.timeGoal
        self.update()
    }
    
    mutating func addTimer(startTime: TimeInterval, endTime: TimeInterval?) {
        if let endTime, let id {
            if let lastTimer = timers.last {
                guard let firstEntry = lastTimer.entries.first, let lastEntry = lastTimer.entries.last else { return }
                if startTime < firstEntry.startTime && endTime > lastEntry.endTime ?? lastEntry.startTime {
                    // Throw Error
                }
            }
            
            let timers = TimeObject.generateTimers(from: Date(timeIntervalSince1970: startTime), to: Date(timeIntervalSince1970: endTime), for: id)
            for timer in timers {
                self.timers.append(timer)
                timer.updateFirebase()
            }
            self.timers.sort(by: { $0.date < $1.date })
        } else {
            if let todayTimer {
                if !todayTimer.isActive, let index = timers.firstIndex(of: todayTimer) {
                    timers[index].start(at: startTime)
                    timers[index].updateFirebase()
                }
            } else if let id {
                let timer = TimeObject(taskId: id, date: Date(timeIntervalSince1970: startTime))
                timer.updateFirebase()
                self.timers.append(timer)
            }
        }
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
            self.timers.sort(by: { $0.date < $1.date })
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
    
    private func update() {
        let service = FirebaseFirestoreService()
        service.update(task: self)
    }
    
}
