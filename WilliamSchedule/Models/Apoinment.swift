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
    let endDate: String
    let type: String
    
    init(dictionary: [String: Any]) {
        self.patient = dictionary["patient"] as? String ?? ""
        self.date = dictionary["date"] as? String ?? ""
        self.endDate = dictionary["endDate"] as? String ?? ""
        self.type = dictionary["type"] as? String ?? ""
    }
}
