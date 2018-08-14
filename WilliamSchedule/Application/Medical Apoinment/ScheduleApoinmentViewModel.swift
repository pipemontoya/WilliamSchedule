//
//  ScheduleApoinmentViewModel.swift
//  WilliamSchedule
//
//  Created by Andres Montoya on 8/14/18.
//  Copyright © 2018 WilliamsMedical. All rights reserved.
//

import Foundation
import Firebase

enum Doc: String {
    case apointment = "Apoinments"
}

class ScheduleApoinmentViewModel: NSObject {
    private static let db = Firestore.firestore()
    
    static func createApoinment(patientName: Any, date: Any, hour: Any, docType: Doc){
        let apoinment = ["patient": patientName, "date": date, "hour": hour]
        addApoinment(data: apoinment, doc: docType)
    }
    
    static func addApoinment(data: [String: Any], doc: Doc) {
        var ref: DocumentReference? = nil
        ref = db.collection(doc.rawValue).addDocument(data: data, completion: { (err) in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        })
    }
}
