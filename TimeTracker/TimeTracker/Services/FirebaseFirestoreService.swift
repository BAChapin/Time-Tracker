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
    
    public func add(task: TimerTask) {
        do {
            try db.collection(Collection.task.path).document().setData(from: task)
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    public func fetchTasks(for userId: String, _ taskHandler: @escaping ([TimerTask]) -> Void) {
        if taskListener == nil {
            taskListener = db.collection(Collection.task.path)
                .whereField("userId", isEqualTo: userId)
                .addSnapshotListener({ (querySnapshot, error) in
                
                    guard let documents = querySnapshot?.documents else {
                        return
                    }
                    
                    let tasks = documents.compactMap { documentSnapshot in
                        let result = Result { try documentSnapshot.data(as: TimerTask.self) }
                        
                        switch result {
                        case .success(let task):
                            return task
                        case .failure(let error):
                            print(error.localizedDescription)
                            return nil
                        }
                    }
                    
                    taskHandler(tasks)
            })
        }
    }
    
    public func unsubscribe() {
        if taskListener != nil {
            taskListener?.remove()
            taskListener = nil
        }
    }
}
