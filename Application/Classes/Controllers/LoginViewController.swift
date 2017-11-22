//
//  ViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 13/10/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import PromiseKit

class LoginViewController: UIViewController {
    
    //    let rootRef = Database.database().reference()
    let API = APIManager.shared
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    var fbLoginSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureFacebookLogin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Check if user is set, login if true
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: Segues.toMainSegueKey, sender: nil)
        } else {
            print("We have to login before we can continue!")
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces), email != "" else { return }
        guard let password = passwordTextField.text, password != "" else { return }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        firstly {
            API.FRBPKLogin(email: email, password: password)
            }.then { user in
                self.performSegue(withIdentifier: Segues.toMainSegueKey, sender: nil)
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }.catch { error in
                print("Error signing in! \(error.localizedDescription)")
                //TODO: Show error message
        }
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces), email != "" else { return }
        guard let password = passwordTextField.text, password != "" else { return }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        firstly {
            API.FRBPKRegister(email: email, password: password)
            }.then { user in
                self.createUserDocument(user: user)
            }.then {
                self.performSegue(withIdentifier: Segues.toMainSegueKey, sender: nil)
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }.catch { error in
                print("Error registering user! \(error.localizedDescription)")
                //TODO: Show error message
        }
    }
    
    func createUserDocument(user: User) {
        //Registering with facebook can give data for all 4 fields
        //Registering with email only saves email
        let userDocRef = Firestore.firestore().collection("users").document(user.uid)
        
        let userData: [String: Any] = [
            "displayName": user.displayName ?? "",
            "email": user.email ?? "",
            "phoneNumber": user.phoneNumber ?? "",
            "photoURL": user.photoURL?.absoluteString ?? ""
        ]
        
        userDocRef.setData(userData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    // MARK: Facebook login
    
    func configureFacebookLogin() {
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        //facebookLoginButton.publishPermissions = ["publish_actions", "user_managed_groups"]
        facebookLoginButton.delegate = self
    }
    
}

extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print("Error logging in with facebook: \(error.localizedDescription)")
        } else if result.isCancelled {
            print("Login cancelled, result: \(result.debugDescription)")
        } else {
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            firstly {
                API.FRBPKFBLogin(credential: credential)
                }.then { user in
                    self.createUserDocument(user: user)
                }.then {
                    self.performSegue(withIdentifier: Segues.toMainSegueKey, sender: nil)
                }.always {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }.catch { error in
                    print("Error signing in: \(error.localizedDescription)")
                    //TODO: Show error message
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Facebook did logout")
    }
}
