//
//  ScheduleTableViewCell.swift
//  WilliamSchedule
//
//  Created by Andres Montoya on 8/14/18.
//  Copyright © 2018 WilliamsMedical. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var consultant: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var apoinmentType: UILabel!
    
    var apoinment: Apoinment? {
        didSet {
            consultant.text = apoinment?.patient
            dateLabel.text = apoinment?.date
            apoinmentType.text = apoinment?.type
        }
    }
}
