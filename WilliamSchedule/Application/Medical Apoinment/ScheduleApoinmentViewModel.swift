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
    case consultant = "Consultants"
}

protocol ScheduleApoinmentDelegate: class {
    func validSchedule(isvalid valid: Bool, date: String)
}

class ScheduleApoinmentViewModel: NSObject {
    static weak var delegate: ScheduleApoinmentDelegate?
    private static let db = Firestore.firestore()
    
    static func createApoinment(patientName: Any, date: Any, type: Any, docType: Doc){
        let apoinment = ["patient": patientName, "date": date, "type": type]
        addApoinment(data: apoinment, doc: docType)
    }
    
    private static func addApoinment(data: [String: Any], doc: Doc) {
        var ref: DocumentReference? = nil
        ref = db.collection(doc.rawValue).addDocument(data: data, completion: { (err) in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        })
    }
    
    private static func validateDateHour(doc: Doc, date: String, viewController: UIViewController, handler: ((_ valid: Bool, _ dateValidated: String) -> ())?) {
        db.collection(doc.rawValue).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents where (document.data()["date"] as? String == date ) {
                    viewController.alert(title: "Lo sentimos!", message: "Ya existe una cita agendada a esta hora")
                    delegate?.validSchedule(isvalid: false, date: date)
                    handler?(false, date)
                    return
                }
                handler?(true, date)
                delegate?.validSchedule(isvalid: true, date: date)
            }
        }
    }
    
    static func validateDate(_ date: Date, viewController: UIViewController, handler: ((_ valid: Bool, _ dateValidated: String)-> ())?) {
        let date = stringDate(date: date)
        validateDateHour(doc: .apointment, date: date, viewController: viewController, handler: handler)
    }
    
    static func stringDate(date: Date) -> String {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        guard let day = components.day,
            let month = components.month,
            let year = components.year,
            let hour = components.hour,
            let minute = components.minute else {return ""}
        let date = "\(day)/\(month)/\(year) \(hour):\(minute)"
        return date
    }
    
    static func roundDatePicker(minuteInterval: Int, date: Date) -> Date {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.month, .day, .year, .hour, .minute], from: date)
        guard var hour = dateComponents.hour, var minute = dateComponents.minute else {
            print("something went wrong")
            return Date()
        }

        let intervalRemainder = minute % minuteInterval
        if intervalRemainder > 0 {
            // need to correct the date
            minute += minuteInterval - intervalRemainder
            if minute >= 60 {
                hour += 1
                minute -= 60
            }
            
            // update datecomponents
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            // get the corrected date
            guard let roundedDate = calendar.date(from: dateComponents) else {
                print("something went wrong")
                return Date()
            }
            return roundedDate
        }
        return Date()
    }
}

