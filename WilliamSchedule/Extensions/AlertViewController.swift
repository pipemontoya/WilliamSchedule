//
//  AlertViewController.swift
//  WilliamSchedule
//
//  Created by Andres Montoya on 8/15/18.
//  Copyright © 2018 WilliamsMedical. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    func alert(title: String?, message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = self.view.bounds
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler))
        present(alert, animated: true, completion: { })
    }}
