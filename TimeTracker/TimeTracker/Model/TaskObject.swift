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
    var hasActiveTimer: Bool?
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
        return hasActiveTimer ?? false
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
        case hasActiveTimer
    }
    
    mutating func fetchTimers() async {
        do {
            await self.fetchWeeksTimers()
            if self.timers.isEmpty && self.isActive {
                await self.fetchActiveTimer()
            }
        }
    }
    
    private mutating func fetchWeeksTimers() async {
        do {
            let service = FirebaseFirestoreService()
            let timers = await service.fetchWeeksTimers(for: self.id!)
            switch timers {
            case .success(let timers):
                self.timers = timers
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private mutating func fetchActiveTimer() async {
        do {
            let service = FirebaseFirestoreService()
            let timer = await service.fetchActiveTimer(for: self.id!)
            switch timer {
            case .success(let timer):
                self.timers = [timer]
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    mutating func stop() {
        if let activeTimer {
            let index = timers.firstIndex(of: activeTimer)
            timers[index!].stop()
        }
        self.setTimer(active: false)
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
        self.setTimer()
    }
    
    private mutating func setTimer(active: Bool = true) {
        self.hasActiveTimer = active
        let service = FirebaseFirestoreService()
        service.update(task: self)
    }
    
}
