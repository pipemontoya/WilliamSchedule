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
    @IBOutlet weak var openButton: UIButton!
    
    var isPress = false
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
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "open" {
            guard let destinationVC = segue.destination as? PatientDetailViewController else {
                return
            }
            destinationVC.constltant = consultantsData[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
  
    @IBAction func addConsultant(_ sender: UIButton) {
        isPress = !isPress
        if isPress {
            sender.setImage(UIImage(named: "close"), for: .normal)
            animate(duration: 0.5, constant: 180)
            return
        }
        sender.setImage(UIImage(named: "open"), for: .normal)
        animate(duration: 0.5, constant: 16)
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
        animate(duration: 0.5, constant: 16)
        isPress = false
        openButton.setImage(UIImage(named: "open"), for: .normal)
        consultantName.text = ""
        birthdateField.text = ""
        phoneFiled.text = ""
        ConsultantsViewModel.countConsultants(doc: .consultant)
        tableView.reloadData()
    }
    
    func animate(duration: Double, constant: CGFloat) {
        UIView.animate(withDuration: duration) {
            self.tableViewConstraint.constant = constant
            self.view.layoutIfNeeded()
        }
    }
}

extension PatientsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "open", sender: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            ConsultantsViewModel.deleteCounsultant(docType: .consultant, docName: consultantsData[indexPath.row].consultantName, vc: self) { [weak self] (isDeleted) in
                if isDeleted {
                    self?.consultantsData.remove(at: indexPath.row)
                    self?.countConsultants = self?.consultantsData.count ?? 0
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension PatientsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countConsultants
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "consultants", for: indexPath) as? ConsultantsTableViewCell else {
            return UITableViewCell()
        }
        guard consultantsData.count != 0 else {return UITableViewCell()}
        cell.consultant = consultantsData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
}

extension PatientsViewController: ConsultantDelegate {
    func countConsultants(numberConsultants: Int, consultants: [Consultant]) {
        countConsultants = numberConsultants
        consultantsData = consultants
        tableView.reloadData()
    }
}
