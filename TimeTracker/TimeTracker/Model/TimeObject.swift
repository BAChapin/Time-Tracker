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
        self.taskId = taskId
        self.date = date.timeIntervalSince1970
        let entry = TimeEntry(startTime: self.date)
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
    
    mutating func stop() {
        if let activeEntry {
            let index = entries.firstIndex(of: activeEntry)
            entries[index!].stop()
        }
        updateFirebase()
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
}
