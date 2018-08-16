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
    
    static func createApoinment(patientName: Any, date: Any, endDate: Any, type: Any, docType: Doc) {
        let apoinment = ["patient": patientName, "date": date, "endDate": endDate, "type": type]
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
    
    private static func validateDateHour(
        doc: Doc,apoinmentType: String,
        date: String, endDate: String,
        viewController: UIViewController,
        handler: ((_ valid: Bool, _ dateValidated: String, _ endDate: String) -> ())?) {
        db.collection(doc.rawValue).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if querySnapshot!.documents.count == 0 {
                    delegate?.validSchedule(isvalid: true, date: date)
                    handler?(true, date, endDate)
                } else {
                    var countBool = 0
                    for document in querySnapshot!.documents {
                        let isValidated = validatehour(
                            dictionary: document.data(),
                            apoinmentType,
                            vc: viewController,
                            actualDateString: date,
                            actualEndDate: endDate)
                        if !isValidated {
                            countBool += 1
                        }
                    }
                    if countBool != 0 {
                        delegate?.validSchedule(isvalid: false, date: date)
                        handler?(false, date, endDate)
                    } else {
                        delegate?.validSchedule(isvalid: true, date: date)
                        handler?(true, date, endDate)
                    }
                }
            }
        }
    }
    
    private static func validatehour(
        dictionary: [String: Any],
        _ apoinmentType: String,
        vc:UIViewController, actualDateString: String,
        actualEndDate: String) -> Bool {
        
        let apoinment = Apoinment(dictionary: dictionary)
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd/MM/yyyy HH:mm"
        let apoinmentDate: Date? = dateFormatterGet.date(from: apoinment.date)
        let apointmentEndDate: Date? = dateFormatterGet.date(from: apoinment.endDate)
        let actualDate: Date? = dateFormatterGet.date(from: actualDateString)
        let actualEndDate: Date? = dateFormatterGet.date(from: actualEndDate)
        
        if actualDate == apoinmentDate {
            vc.alert(
                title: "no es posible agendar la cita",
                message: "Ya tiene agragada una cita a esta hora, por favor revisa las citas programadas")
            return false
        } else if (actualDate! >= apointmentEndDate!) && (actualDate! > apoinmentDate!) {
            return true
        } else if (actualEndDate! <= apoinmentDate!) && (actualDate! < apoinmentDate!) {
            return true
        } else {
            vc.alert(
                title: "no es posible agendar la cita",
                message: "Ya tiene agragada una cita a esta hora, por favor revisa las citas programadas")
            return false
        }
    }
    
    private static func components(_ date: Date) -> (Int, Int) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        guard let hour = components.hour,
            let minute = components.minute else {return (0,0)}
        return (hour, minute)
    }
    
    static func validateDate(_ date: Date, apoinmentType: String, viewController: UIViewController, handler: ((_ valid: Bool, _ dateValidated: String, _ endDate: String)-> ())?) {
        let endDate: Date?
        if apoinmentType == "seguimiento" {
            endDate = date.addingTimeInterval(15 * 60)
        } else {
            endDate = date.addingTimeInterval(30 * 60)
        }
        let endApoinment = stringDate(date: endDate ?? Date())
        let date = stringDate(date: date)
        validateDateHour(doc: .apointment, apoinmentType: apoinmentType, date: date, endDate: endApoinment, viewController: viewController, handler: handler)
    }
    
    static func stringDate(date: Date) -> String {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        guard let day = components.day,
            let month = components.month,
            let year = components.year,
            let hour = components.hour,
            let minute = components.minute else {return ""}
        let formatter = DateFormatter()
        formatter.dateFormat = ""
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

