//
//  APIManager.swift
//  TriMeter
//
//  Created by Bram Nouwen on 7/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import Firebase
import PromiseKit

class APIManager: NSObject {
    
    static let shared = APIManager()
    
    override init() {
        
    }
    
    // Firebase PromiseKit login
    func FRBPKLogin(email: String, password: String) -> Promise<User> {
        return Promise { fulfill, reject in
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    reject(error)
                } else if let user = user {
                    print("User signed in! \(user)")
                    fulfill(user)
                }
            }
        }
    }
    
    // Firebase PromiseKit register
    func FRBPKRegister(email: String, password: String) -> Promise<User> {
        return Promise { fulfill, reject in
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    reject(error)
                } else if let user = user {
                    print("User registered! \(user)")
                    fulfill(user)
                }
            }
        }
    }
    
    // Firebase PromiseKit Facebook login
    func FRBPKFBLogin(credential: AuthCredential) -> Promise<User> {
        return Promise { fulfill, reject in
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    reject(error)
                } else if let user = user {
                    print("User signed in! \(user)")
                    fulfill(user)
                }
            }
        }
    }
    
}
