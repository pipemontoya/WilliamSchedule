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
    
    @IBOutlet weak var ConsultantsPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var countConsultant = 0
    var consultantsData: [Consultant] = []
    var consultant: Consultant? = nil
    var apoinmentType = ""
    var hourIsValid = false
    var dateValidated = ""
    var roundedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundedDate = ScheduleApoinmentViewModel.roundDatePicker(minuteInterval: datePicker.minuteInterval, date: datePicker.date)
        datePicker.date = roundedDate
        if datePicker.minuteInterval == 15 {
            apoinmentType = "seguimiento"
        }
        datePicker.minimumDate = roundedDate
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        ConsultantsPicker.delegate = self
        ConsultantsPicker.dataSource = self
        ScheduleApoinmentViewModel.delegate = self
        ConsultantsViewModel.delegate = self
        ConsultantsViewModel.countConsultants(doc: .consultant)
    }

    @objc func dateChanged(_ sender: UIDatePicker) {
        //ScheduleApoinmentViewModel.validateDate(sender.date, apoinmentType: apoinmentType, viewController: self, handler: nil)
    }
    
    @IBAction func apoinmentType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            datePicker.minuteInterval = 15
            apoinmentType = "seguimiento"
        case 1:
            datePicker.minuteInterval = 30
            apoinmentType = "anual"
        default:
            break
        }
    }
    
    
    @IBAction func scheduleApoinment(_ sender: UIButton) {
        guard consultant?.consultantName != nil else {
            alert(title: "Error", message: "Debes escoger el nombre del paciente para agendar")
            return
        }
        
        ScheduleApoinmentViewModel.validateDate(datePicker.date, apoinmentType: apoinmentType, viewController: self) { [weak self] (isValid, dateValidated)  in
            if isValid {
                ScheduleApoinmentViewModel.createApoinment(
                    patientName: self?.consultant?.consultantName ?? "",
                    date: dateValidated,
                    type: self?.apoinmentType ?? "",
                    docType: .apointment)
            }
        }
    }
    
}

extension MedicalApoinmentViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        consultant = consultantsData[row]
    }
}

extension MedicalApoinmentViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countConsultant
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        consultant = consultantsData[row]
        return consultantsData[row].consultantName
    }
}

extension MedicalApoinmentViewController: ConsultantDelegate {
    func countConsultants(numberConsultants: Int, consultants: [Consultant]) {
        countConsultant = numberConsultants
        consultantsData = consultants
        ConsultantsPicker.reloadAllComponents()
    }
}

extension MedicalApoinmentViewController: ScheduleApoinmentDelegate {
    func validSchedule(isvalid valid: Bool, date: String) {
        hourIsValid = valid
        guard !valid else {return}
        datePicker.setDate(roundedDate, animated: true)
    }
}

