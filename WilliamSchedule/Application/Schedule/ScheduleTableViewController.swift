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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScheduleModelView.delegate = self
        ScheduleModelView.countApointments(doc: .apointment)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countApointments
    }
    
}

extension ScheduleTableViewController: ScheduleDelegate {
    func countDocuments(count: Int) {
        countApointments = count
        tableView.reloadData()
    }
    
    
}
