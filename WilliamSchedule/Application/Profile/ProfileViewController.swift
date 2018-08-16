//
//  ProfileViewController.swift
//  WilliamSchedule
//
//  Created by Andres Montoya on 8/14/18.
//  Copyright © 2018 WilliamsMedical. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.profileName.text = user?.displayName ?? ""
            let data = try? Data(contentsOf: user?.photoURL ?? URL(fileURLWithPath: ""))
            if let imageData = data {
                let image = UIImage(data: imageData)
                self.photo.image = image
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = "Perfil"
    }

    @IBAction func logOut(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            if #available(iOS 11.0, *) {
                appdelegate.startStoryboard()
            } else {
                // Fallback on earlier versions
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
