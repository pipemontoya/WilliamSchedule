//
//  ScheduleTableViewController.swift
//  WilliamSchedule
//
//  Created by Andres Montoya on 8/14/18.
//  Copyright © 2018 WilliamsMedical. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController {
    
    var countApointments = 0
    var apoinmentsScheduled: [Apoinment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScheduleModelView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = "Citas Programadas"
        ScheduleModelView.countApointments(doc: .apointment)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countApointments
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "schedule", for: indexPath) as? ScheduleTableViewCell else {
            return UITableViewCell()
        }
        guard apoinmentsScheduled.count != 0 else {return UITableViewCell()}
        cell.apoinment = apoinmentsScheduled[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
}

extension ScheduleTableViewController: ScheduleDelegate {
    func countDocuments(count: Int, apoinments: [Apoinment]) {
        countApointments = count
        apoinmentsScheduled = apoinments
        tableView.reloadData()
    }

}


