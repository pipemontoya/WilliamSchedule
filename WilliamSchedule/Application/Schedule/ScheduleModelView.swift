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
    func countDocuments(count: Int, apoinments: [Apoinment])
}

class ScheduleModelView: NSObject {
    static weak var delegate: ScheduleDelegate? = nil
    static let db = Firestore.firestore()
    static var count = 0
    static var apoinments: [Apoinment] = []
    
    private static func setupdb() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    static func countApointments(doc: Doc) {
        setupdb()
        
        db.collection(doc.rawValue).order(by: "date", descending: false).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var apoinments: [Apoinment] = []
                for document in querySnapshot!.documents where document.data().count == 4 {
                    apoinments.append(Apoinment(dictionary: document.data()))
                }
                self.apoinments = apoinments
                delegate?.countDocuments(count: querySnapshot?.documents.count ?? 0, apoinments: apoinments)
            }
        }
    }
}
