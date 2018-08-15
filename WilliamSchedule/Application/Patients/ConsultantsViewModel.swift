//
//  ConsultantsViewModel.swift
//  WilliamSchedule
//
//  Created by Andres Montoya on 8/15/18.
//  Copyright © 2018 WilliamsMedical. All rights reserved.
//

import Foundation
import Firebase

protocol ConsultantDelegate: class {
    func countConsultants(numberConsultants: Int, consultants: [Consultant])
}

class ConsultantsViewModel: NSObject {
    
    static weak var delegate: ConsultantDelegate? = nil
    private static let db = Firestore.firestore()
    static var consultants: [Consultant] = []
    
    
    static func createConsultant(patientName: Any, birthDate: Any, phone: Any, docType: Doc){
        let consultant = ["name": patientName, "birthDate": birthDate, "phone": phone]
        addConsultant(data: consultant, doc: docType)
    }
    
    private static func addConsultant(data: [String: Any], doc: Doc) {
        var ref: DocumentReference? = nil
        ref = db.collection(doc.rawValue).addDocument(data: data, completion: { (err) in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        })
    }
    
    private static func setupdb() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    static func countConsultants(doc: Doc) {
        setupdb()
        db.collection(doc.rawValue).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var consultants: [Consultant] = []
                for document in querySnapshot!.documents where document.data().count == 3 {
                    consultants.append(Consultant(dictionary: document.data()))
                }
                self.consultants = consultants
                delegate?.countConsultants(numberConsultants: querySnapshot?.documents.count ?? 0, consultants: consultants)
            }
        }
    }
}
