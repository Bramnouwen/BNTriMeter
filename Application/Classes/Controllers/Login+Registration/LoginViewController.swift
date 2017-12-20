//
//  LoginViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 24/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import IBAnimatable
import PromiseKit

class LoginViewController: GradientViewController {
    
    let API = APIManager.shared
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBOutlet weak var emailTextField: AnimatableTextField!
    @IBOutlet weak var passwordTextField: AnimatableTextField!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: AnimatableButton!
    @IBOutlet weak var toRegisterButton: UIButton!
    @IBOutlet weak var showHidePasswordButton: UIButton!
    
    var errorCounter = 1
    
    // Constraints
    @IBOutlet weak var triMeterToLogoDistance: NSLayoutConstraint!
    @IBOutlet weak var emailToDescriptionDistance: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.text = L10n.Login.description
        emailTextField.placeholder = L10n.Common.email
        emailTextField.placeholderColor = .white
        passwordTextField.placeholder = L10n.Common.password
        passwordTextField.placeholderColor = .white
        forgotPasswordButton.setTitle(L10n.Login.forgot, for: .normal)
        toRegisterButton.setTitle(L10n.Common.toRegister, for: .normal)
        errorLabel.text = L10n.Login.errorOne
    }

    @IBAction func forgotPasswordClicked(_ sender: Any) {
        //TODO: Send password reset email
        errorLabel.text = L10n.Login.forgotError
        errorLabel.isHidden = false
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces), email != "" else { return }
        guard let password = passwordTextField.text, password != "" else { return }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        firstly {
            API.FRBPKLogin(email: email, password: password)
            }.then { user in
                self.performSegue(withIdentifier: Segues.toMain, sender: nil)
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }.catch { error in
                print("Error signing in! \(error.localizedDescription)")
                self.errorLabel.isHidden = false
                switch self.errorCounter {
                    case 2: self.errorLabel.text = L10n.Login.errorTwo
                    case 3: self.errorLabel.text = L10n.Login.errorThree
                default: print("Default switch option necessary.")
                }
                self.errorCounter += 1
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
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
            return
        }
        loginButton.isEnabled = true
        loginButton.alpha = 1
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// Screen support

import Device
extension LoginViewController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //iphone 7+ (5.5) = 330, iphone 7 (4.7) = 300, iphone 5 (4) = 240,
        switch Device.size() {
        case .screen4Inch: //iPhone 5
            print("5")
            triMeterToLogoDistance.constant = 0
            emailToDescriptionDistance.constant = 40
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
