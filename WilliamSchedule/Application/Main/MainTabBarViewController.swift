//
//  MainTabBarViewController.swift
//  WilliamSchedule
//
//  Created by Andres Montoya on 8/14/18.
//  Copyright © 2018 WilliamsMedical. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    // Storyboards
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalPushManager.shared.requestAuthorization()
        viewControllers = ViewControllersService.viewcontrollers(views: [.patients, .medicalApoinment, .schedule, .profile])
    }

}

extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
