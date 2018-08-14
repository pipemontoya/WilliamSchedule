//
//  ScheduleModelView.swift
//  WilliamSchedule
//
//  Created by Andres Montoya on 8/14/18.
//  Copyright © 2018 WilliamsMedical. All rights reserved.
//

import Foundation
import Firebase

protocol ScheduleDelegate: class {
    func countDocuments(count: Int)
}

class ScheduleModelView: NSObject {
    static weak var delegate: ScheduleDelegate? = nil
    static let db = Firestore.firestore()
    static var count = 0
    
    private static func setupdb() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    static func countApointments(doc: Doc) {
        setupdb()
        db.collection(doc.rawValue).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                delegate?.countDocuments(count: querySnapshot?.documents.count ?? 0)
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
}
