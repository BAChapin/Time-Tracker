//
//  Task.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/12/22.
//

import Foundation
import FirebaseFirestoreSwift

struct TimerTask: Codable, Hashable {
    @DocumentID var id: String?
    let userId: String
    var created: Date = Date()
    var name: String
    var timeGoal: Double?
    
}
