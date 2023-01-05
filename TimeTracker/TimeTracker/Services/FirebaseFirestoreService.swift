//
//  FirebaseFirestoreService.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/8/22.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

enum FirestoreError: Error {
    case decodingError
    case noEntries
    case unknown
}

class FirebaseFirestoreService {
    
    private let db = Firestore.firestore()
    private var taskListener: ListenerRegistration?
    
    enum Collection: String {
        case task = "tasks"
        case timer = "timers"
        
        var path: String {
            return self.rawValue
        }
    }
    
    public func add(task: TaskObject) {
        do {
            try db.collection(Collection.task.path).document().setData(from: task)
        } catch (let error) {
            // TODO: Add proper error handling
            print(error.localizedDescription)
        }
    }
    
    public func update(task: TaskObject) {
        do {
            try db.collection(Collection.task.path).document(task.id!).setData(from: task, merge: false)
        } catch (let error) {
            // TODO: Add proper error handling
            print(error.localizedDescription)
        }
    }
    
    public func add(timer: TimeObject) {
        do {
            if let timerId = timer.id {
                try db.collection(Collection.timer.path).document(timerId).setData(from: timer)
            } else {
                try db.collection(Collection.timer.path).document().setData(from: timer)
            }
        } catch (let error) {
            // TODO: Add proper error handling
            print(error.localizedDescription)
        }
        
    }
    
    public func add(timers: [TimeObject]) {
        do {
            let batch = db.batch()
            
            for timer in timers {
                var ref = db.collection(Collection.timer.path).document()
                if let id = timer.id {
                    ref = db.collection(Collection.timer.path).document(id)
                }
                try batch.setData(from: timer, forDocument: ref)
            }
            
            batch.commit()
        } catch (let err) {
            print(err.localizedDescription)
        }
    }
    
    public func fetchTasks(for userId: String, _ taskHandler: @escaping (DocumentChangeType, TaskObject) -> Void) {
        if taskListener == nil {
            taskListener = db.collection(Collection.task.path)
                .whereField("userId", isEqualTo: userId)
                .order(by: "created")
                .addSnapshotListener({ (querySnapshot, error) in
                
                    guard let documentChanges = querySnapshot?.documentChanges else {
                        return
                    }
                    
                    documentChanges.forEach { change in
                        do {
                            let task = try change.document.data(as: TaskObject.self)
                            taskHandler(change.type, task)
                        } catch (let error) {
                            print(error.localizedDescription)
                        }
                    }
            })
        }
    }
    
    @MainActor
    public func fetchWeeksTimers(for taskId: String) async -> Result<[TimeObject], FirestoreError> {
        do {
            let snapshot = try await db.collection(Collection.timer.path)
                .whereField("taskId", isEqualTo: taskId)
                .order(by: "date", descending: true)
                .limit(to: 8)
                .getDocuments()
            let timers = snapshot.documents.compactMap { document in
                return try? document.data(as: TimeObject.self)
            }
            return .success(timers)
        } catch ( _) {
            return .failure(.unknown)
        }
    }
    
    public func unsubscribe() {
        if taskListener != nil {
            taskListener?.remove()
            taskListener = nil
        }
    }
}
