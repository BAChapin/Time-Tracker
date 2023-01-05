//
//  Timer.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/20/22.
//

import Foundation
import FirebaseFirestoreSwift

struct TimeObject: Codable, Hashable, Identifiable {
    
    @DocumentID var id: String?
    let taskId: String
    var date: TimeInterval = Date().timeIntervalSince1970
    var entries: [TimeEntry]
    
    init(taskId: String, date: Date = Date()) {
        self.id = UUID().uuidString
        self.taskId = taskId
        self.date = date.startOfDay.timeIntervalSince1970
        let entry = TimeEntry(startTime: date.timeIntervalSince1970)
        self.entries = [entry]
    }
    
    var totalTime: TimeInterval {
        return entries.reduce(0) { partialResult, entry in
            return partialResult + (entry.elapsedTime)
        }
    }
    var isActive: Bool {
        return entries.contains { entry in
            entry.isActive
        }
    }
    var activeEntry: TimeEntry? {
        return entries.first(where: { $0.isActive })
    }
    
    mutating func stop(at currentTime: Date = Date(), _ quietly: Bool = false) {
        if let activeEntry {
            let index = entries.firstIndex(of: activeEntry)
            let currentTime = currentTime.timeIntervalSince1970
            entries[index!].stop(at: currentTime)
        }
        if !quietly {
            updateFirebase()
        }
    }
    
    mutating func start() {
        let entry = TimeEntry(startTime: Date().timeIntervalSince1970)
        entries.append(entry)
        updateFirebase()
    }
    
    func updateFirebase() {
        let service = FirebaseFirestoreService()
        service.add(timer: self)
    }
    
}

extension TimeObject {
    static var testTimer: TimeObject = .init(taskId: "Test ID", date: Date.startOfDay())
    
    static func generateTimers(from d1: Date = Date(), to d2: Date, for taskId: String) -> [TimeObject] {
        var returnTimers: [TimeObject] = []
        let range = Date.dateRange(from: d1, to: d2)
        for date in range {
            var newTimer = TimeObject(taskId: taskId, date: date)
            newTimer.stop(at: d2, true)
            returnTimers.append(newTimer)
        }
        return returnTimers
    }
}
