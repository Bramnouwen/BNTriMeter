//
//  RegisterOneViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 24/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import IBAnimatable
import PromiseKit
import Firebase

class RegisterOneViewController: GradientViewController {
    
    let API = APIManager.shared
    let db = Firestore.firestore()

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var emailTextField: AnimatableTextField!
    @IBOutlet weak var passwordTextField: AnimatableTextField!
    
    @IBOutlet weak var continueButton: AnimatableButton!
    @IBOutlet weak var toLoginButton: UIButton!
    @IBOutlet weak var showHidePasswordButton: UIButton!
    
    // Constraints
    @IBOutlet weak var emailToDescriptionDistance: NSLayoutConstraint!
    @IBOutlet weak var triMeterToLogoDistance: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.text = L10n.Register.descriptionOne
        emailTextField.placeholder = L10n.Common.email
        emailTextField.placeholderColor = .white
        passwordTextField.placeholder = L10n.Common.password
        passwordTextField.placeholderColor = .white
        continueButton.setTitle(L10n.Common.continueText, for: .normal)
        toLoginButton.setTitle(L10n.Common.toLogin, for: .normal)
        
        
    }

    @IBAction func continueButtonClicked(_ sender: Any) {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces),
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        firstly {
            API.FRBPKRegister(email: email, password: password)
            }.then { user in
                self.createUserDocument(user: user)
            }.then {
                self.performSegue(withIdentifier: Segues.toRegisterTwo, sender: nil)
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }.catch { error in
                print("Error registering user! \(error.localizedDescription)")
                //TODO: Show error message
        }
        
    }
    
    @IBAction func showHidePasswordButtonClicked(_ sender: Any) {
        if passwordTextField.isSecureTextEntry {
            passwordTextField.isSecureTextEntry = false
            showHidePasswordButton.setImage(#imageLiteral(resourceName: "HidePassword"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            showHidePasswordButton.setImage(#imageLiteral(resourceName: "ShowPassword"), for: .normal)
        }
    }
    
    @IBAction func emailEditingChanged(_ sender: Any) {
        toggleLoginButton()
        guard emailTextField.text != "" else {
            emailTextField.alpha = 0.5
            return
        }
        emailTextField.alpha = 1
    }
    
    @IBAction func passwordEditingChanged(_ sender: Any) {
        toggleLoginButton()
        guard passwordTextField.text != "" else {
            passwordTextField.alpha = 0.5
            return
        }
        passwordTextField.alpha = 1
    }
    
    func toggleLoginButton() {
        guard emailTextField.text != "" && passwordTextField.text != "" else {
            continueButton.isEnabled = false
            continueButton.alpha = 0.5
            return
        }
        continueButton.isEnabled = true
        continueButton.alpha = 1
    }
    
    func createUserDocument(user: User) {
        let userDocRef = db.collection("users").document(user.uid)
        
        let userData: [String: Any] = [
            "email": user.email ?? ""
        ]
        
        userDocRef.setData(userData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
}

// Screen support

import Device
extension RegisterOneViewController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //iphone 7+ (5.5) = 330, iphone 7 (4.7) = 300, iphone 5 (4) = 240,
        switch Device.size() {
        case .screen4Inch: //iPhone 5
            print("5")
            emailToDescriptionDistance.constant = 12
            triMeterToLogoDistance.constant = 0
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
