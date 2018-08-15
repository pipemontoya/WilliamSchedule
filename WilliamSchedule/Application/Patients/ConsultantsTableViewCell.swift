//
//  ConsultantsTableViewCell.swift
//  WilliamSchedule
//
//  Created by Andres Montoya on 8/15/18.
//  Copyright © 2018 WilliamsMedical. All rights reserved.
//

import UIKit

class ConsultantsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var consultant: Consultant? {
        didSet {
            name.text = consultant?.consultantName
            birthdateLabel.text = consultant?.birthDate
            phoneLabel.text = consultant?.phone
        }
    }

}
