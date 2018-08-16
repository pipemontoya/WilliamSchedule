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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = "Agendar"
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
            alert(title: "No tienes pacientes", message: "Debes registrar pacientes para aguendar citas") { [weak self] (_) in
                self?.tabBarController?.selectedIndex = 0
            }
            return
        }
        
        ScheduleApoinmentViewModel.validateDate(datePicker.date, apoinmentType: apoinmentType, viewController: self) { [weak self] (isValid, dateValidated, endDate)  in
            if isValid {                
                ScheduleApoinmentViewModel.createApoinment(
                    patientName: self?.consultant?.consultantName ?? "",
                    date: dateValidated,
                    endDate: endDate,
                    type: self?.apoinmentType ?? "",
                    docType: .apointment)
            }
            self?.alert(title: "Cita Agendada", message: "La cita fué agendada con éxito", handler: { (_) in
                self?.tabBarController?.selectedIndex = 2
            })
        }
    }
    
}

extension MedicalApoinmentViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard consultantsData.count != 0 else { return }
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
    func isAdded(consultatn isAdded: Bool) {
        
    }
    
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

