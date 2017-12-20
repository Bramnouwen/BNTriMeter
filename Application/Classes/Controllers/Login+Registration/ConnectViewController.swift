//
//  ConnectViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 24/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import IBAnimatable
import FBSDKLoginKit
import PromiseKit
import Firebase

class ConnectViewController: GradientViewController {
    
    let API = APIManager.shared
    let db = Firestore.firestore()
    
    @IBOutlet weak var registerButton: AnimatableButton!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    @IBOutlet weak var stravaButton: AnimatableButton!
    @IBOutlet weak var toLoginButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    
    @IBOutlet weak var facebookButtonHeightConstraint: NSLayoutConstraint!
    
    // Constraints
    @IBOutlet var triMeterToLogoDistanceConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerButton.setTitle(L10n.Register.register, for: .normal)
        toLoginButton.setTitle(L10n.Common.toLogin, for: .normal)
        descriptionLabel.text = L10n.Connect.description
        orLabel.text = L10n.Connect.or
        
        configureFacebookLogin()
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        //Delete?
        //Maybe show alert to push for Facebook/Strava login?
    }
    
    @IBAction func facebookButtonClicked(_ sender: Any) {
        // TODO: Facebook connect
    }
    
    @IBAction func stravaButtonClicked(_ sender: Any) {
        // TODO: Strava connect
        
    }
    
    func configureFacebookLogin() {
        facebookButton.readPermissions = ["public_profile", "email", "user_friends"]
        //facebookLoginButton.publishPermissions = ["publish_actions", "user_managed_groups"]
        facebookButton.delegate = self
    }
    
    
    func createUserDocument(user: User) {
        let userDocRef = db.collection("users").document(user.uid)
        
        let userData: [String: Any] = [
            //TODO: Add variable to check if all info is filled out?
            "displayName": user.displayName ?? "",
            "email": user.email ?? "",
            "photoURL": user.photoURL?.absoluteString ?? ""
        ]
        
        userDocRef.setData(userData, options: SetOptions.merge()) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ConnectViewController: FBSDKLoginButtonDelegate {
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
                    self.checkIfUserExists(user: user)
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
    
    func userDoesExist(user: User) -> Bool {
        var doesExist = false
        let docRef = db.collection("users").document(user.uid)
        
        docRef.getDocument { (document, error) in
            if let document = document {
                print("Document data: \(document.data())")
                self.performSegue(withIdentifier: Segues.toRegisterTwo, sender: nil)
                doesExist = true
            } else {
                print("Document does not exist")
                self.createUserDocument(user: user)
                doesExist = false
            }
        }
        return doesExist
    }
    
    func checkIfUserExists(user: User) {
        let docRef = db.collection("users").document(user.uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Document data: \(document.data())")
                self.performSegue(withIdentifier: Segues.toMain, sender: nil)
            } else {
                print("Document does not exist")
                self.createUserDocument(user: user)
                self.performSegue(withIdentifier: Segues.toRegisterTwo, sender: nil)
            }
        }
    }
}

// Screen support

import Device
extension ConnectViewController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //iphone 7+ (5.5) = 330, iphone 7 (4.7) = 300, iphone 5 (4) = 240,
        switch Device.size() {
        case .screen4Inch: //iPhone 5
            print("5")
            triMeterToLogoDistanceConstraint.constant = 0
        case .screen4_7Inch: //iPhone 8
            print("8")
        case .screen5_5Inch: //iPhone 8+
            print("8+")
        case .screen5_8Inch: //iPhone x
            print("X")
        default:
            print("Size not supported")
        }
    }
}
