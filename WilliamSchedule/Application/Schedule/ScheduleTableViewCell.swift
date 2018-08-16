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
    @IBOutlet weak var viewBackgroundCell: UIView!
    
    var apoinment: Apoinment? {
        didSet {
            consultant.text = apoinment?.patient
            dateLabel.text = apoinment?.date
            apoinmentType.text = apoinment?.type
            changeBackground(date: apoinment!)
        }
    }
    
    func changeBackground(date: Apoinment) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let date = dateFormatter.date(from: date.date)
        if Date() > date! {
            viewBackgroundCell.backgroundColor = #colorLiteral(red: 1, green: 0.4019555726, blue: 0.3372226449, alpha: 1)
        } else {
            viewBackgroundCell.backgroundColor = #colorLiteral(red: 0.368627451, green: 0.4588235294, blue: 1, alpha: 1)
        }
    }
}
