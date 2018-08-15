//
//  MedicalApoinmentViewController.swift
//  WilliamSchedule
//
//  Created by Andres Montoya on 8/14/18.
//  Copyright © 2018 WilliamsMedical. All rights reserved.
//

import UIKit
import Firebase

class MedicalApoinmentViewController: UIViewController {
    
    
    @IBOutlet weak var patient: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var HourField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func scheduleApoinment(_ sender: UIButton) {
        
        ScheduleApoinmentViewModel.createApoinment(
            patientName: patient.text ?? "",
            date: dateField.text ?? "",
            hour: HourField.text ?? "",
            docType: .apointment)
    }
}
