//
//  PatientDetailViewController.swift
//  WilliamSchedule
//
//  Created by Andres Montoya on 8/16/18.
//  Copyright © 2018 WilliamsMedical. All rights reserved.
//

import UIKit
import Firebase

class PatientDetailViewController: UIViewController {
    var constltant: Consultant? = nil
    let db = Firestore.firestore()

    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTitleLabel.text = constltant?.consultantName
        nameLabel.text = constltant?.consultantName
        birthLabel.text = "Fecha de nacimiento: \(constltant?.birthDate ?? "")"
        phoneLabel.text = "Teléfono: \(constltant?.phone ?? "")"
    }
    
    @IBAction func writeDate(_ sender: UIButton) {
        ConsultantsViewModel.updateConsultant(
            birthDate: dateField.text ?? "",
            phone: phoneField.text ?? "",
            docType: .consultant,
            docName: constltant?.consultantName ?? "")
        birthLabel.text = dateField.text
        phoneField.text = phoneField.text
        alert(title: "Modificado", message: "Los datos del paciente se modificaron con éxito") { [weak self] (_) in
            self?.tabBarController?.selectedIndex = 0
        }
        
    }
    
}
