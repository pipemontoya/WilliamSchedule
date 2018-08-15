//
//  Consultant.swift
//  WilliamSchedule
//
//  Created by Andres Montoya on 8/15/18.
//  Copyright © 2018 WilliamsMedical. All rights reserved.
//

import Foundation

class Consultant: NSObject {
    
    let consultantName: String
    let birthDate: String
    let phone: String
    
    init(dictionary: [String: Any]) {
        self.consultantName = dictionary["name"] as? String ?? ""
        self.birthDate = dictionary["birthDate"] as? String ?? ""
        self.phone = dictionary["phone"] as? String ?? ""
    }
}
