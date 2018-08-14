//
//  ViewControllersService.swift
//  WilliamSchedule
//
//  Created by Andres Montoya on 8/14/18.
//  Copyright © 2018 WilliamsMedical. All rights reserved.
//

import Foundation
import UIKit

enum SuscribeViewControllers: String {
    case patients = "Patients"
    case medicalApoinment = "MedicalApoinment"
    case profile = "Profile"
}

class ViewControllersService {
    
    private static var suscribedViewControllers: [SuscribeViewControllers] = []
    
    private static func viewController(suscVC: SuscribeViewControllers) -> UIViewController {
        let viewController = UIStoryboard(
            name: suscVC.rawValue,
            bundle: Bundle.main).instantiateInitialViewController() ?? UIViewController()
        return viewController
    }
    
    private static func viewControllers(suscVControllers: [SuscribeViewControllers]) -> [UIViewController] {
        var viewControllers: [UIViewController] = []
        for suscVC in suscVControllers {
            viewControllers.append(viewController(suscVC: suscVC))
        }
        return viewControllers
    }
    
    static func viewcontrollers(views: [SuscribeViewControllers]) -> [UIViewController] {
        suscribedViewControllers = views
        return viewControllers(suscVControllers: views)
    }
}
