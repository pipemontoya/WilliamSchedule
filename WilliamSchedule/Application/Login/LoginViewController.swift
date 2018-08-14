//
//  LoginViewController.swift
//  WilliamSchedule
//
//  Created by Andres Montoya on 8/13/18.
//  Copyright © 2018 WilliamsMedical. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
    }

}
