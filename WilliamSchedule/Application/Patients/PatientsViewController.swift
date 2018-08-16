//
//  PatientsViewController.swift
//  WilliamSchedule
//
//  Created by Andres Montoya on 8/14/18.
//  Copyright © 2018 WilliamsMedical. All rights reserved.
//

import UIKit

class PatientsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var consultantName: UITextField!
    @IBOutlet weak var birthdateField: UITextField!
    @IBOutlet weak var phoneFiled: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    var countConsultants = 0
    var consultantsData: [Consultant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConstraint.constant = 16
        ConsultantsViewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = "Pacientes"
        ConsultantsViewModel.countConsultants(doc: .consultant)
    }
    
    @IBAction func addConsultant(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.tableViewConstraint.constant = 180
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func saveConsultant(_ sender: UIButton) {
        guard consultantName.text != "",
            birthdateField.text != "",
            phoneFiled.text != "" else {
                alert(title: "Error", message: "Todos los campos deben estar diligenciados")
            return
        }
        ConsultantsViewModel.createConsultant(
            patientName: consultantName.text ?? "",
            birthDate: birthdateField.text ?? "",
            phone: phoneFiled.text ?? "",
            docType: .consultant)
        UIView.animate(withDuration: 0.5) {
            self.tableViewConstraint.constant = 16
            self.view.layoutIfNeeded()
        }
        consultantName.text = ""
        birthdateField.text = ""
        phoneFiled.text = ""
    }
}

extension PatientsViewController: UITableViewDelegate {
    
}

extension PatientsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countConsultants
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "consultants", for: indexPath) as? ConsultantsTableViewCell else {
            return UITableViewCell()
        }
        cell.consultant = consultantsData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
}

extension PatientsViewController: ConsultantDelegate {
    func countConsultants(numberConsultants: Int, consultants: [Consultant]) {
        countConsultants = numberConsultants
        consultantsData = consultants
        tableView.reloadData()
    }
    
    
}
