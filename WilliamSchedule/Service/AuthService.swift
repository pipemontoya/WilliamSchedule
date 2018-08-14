//
//  AuthService.swift
//  WilliamSchedule
//
//  Created by Andres Montoya on 8/13/18.
//  Copyright © 2018 WilliamsMedical. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthService {
    
    static let shared = AuthService()
    
    var auth: Auth {
        return Auth.auth()
    }
    var currentUser: User? {
        return auth.currentUser
    }
    var isLogged: Bool {
        return currentUser != nil
    }
}
