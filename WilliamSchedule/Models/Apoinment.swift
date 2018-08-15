//
//  Apoinment.swift
//  WilliamSchedule
//
//  Created by Andres Montoya on 8/14/18.
//  Copyright © 2018 WilliamsMedical. All rights reserved.
//

import Foundation

class Apoinment: NSObject {
    
    let patient: String
    let date: String
    let hour: String
    
    init(dictionary: [String: Any]) {
        self.patient = dictionary["patient"] as? String ?? ""
        self.date = dictionary["date"] as? String ?? ""
        self.hour = dictionary["hour"] as? String ?? ""
    }
}
