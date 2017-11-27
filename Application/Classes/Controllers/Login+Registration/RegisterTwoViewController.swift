//
//  RegisterTwoViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 24/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//
/* Referenced
 - http://swiftdeveloperblog.com/code-examples/create-uidatepicker-programmatically/
 - Internship project
 
 */

import UIKit
import IBAnimatable
import PromiseKit
import Firebase

class RegisterTwoViewController: UIViewController, UITextFieldDelegate {
    
    let API = APIManager.shared
    let db = Firestore.firestore()

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var firstNameTextField: AnimatableTextField!
    @IBOutlet weak var lastNameTextField: AnimatableTextField!
    @IBOutlet weak var dateOfBirthTextField: AnimatableTextField!
    @IBOutlet weak var weightTextField: AnimatableTextField!
    
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var registerButton: AnimatableButton!
    @IBOutlet weak var kilogramButton: UIButton!
    
    var male: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.text = L10n.Register.descriptionTwo
        firstNameTextField.placeholder = L10n.Register.firstName
        firstNameTextField.placeholderColor = .white
        lastNameTextField.placeholder = L10n.Register.lastName
        lastNameTextField.placeholderColor = .white
        dateOfBirthTextField.placeholder = L10n.Register.dateOfBirth
        dateOfBirthTextField.placeholderColor = .white
        weightTextField.placeholder = L10n.Register.weight
        weightTextField.placeholderColor = .white
        genderSegmentedControl.setTitle(L10n.Register.male, forSegmentAt: 0)
        genderSegmentedControl.setTitle(L10n.Register.female, forSegmentAt: 1)
        registerButton.setTitle(L10n.Register.register, for: .normal)
        
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.datePickerMode = .date
        
        dateOfBirthTextField.delegate = self
        dateOfBirthTextField.inputView = datePicker
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.applyGradient()
    }
    
    @IBAction func genderSegmentedControlValueChanged(_ sender: Any) {
        if genderSegmentedControl.selectedSegmentIndex == 0 {
            male = true
        } else {
            male = false
        }
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        guard let user = Auth.auth().currentUser else { return }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //TODO: PromiseKit?
        updateUserDocument(user: user)
        self.performSegue(withIdentifier: Segues.toMain, sender: nil)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func updateUserDocument(user: User) {
        let userDocRef = db.collection("users").document(user.uid)
        
        var weightInKg: Double = 0
        if let weight = weightTextField.text, weight != "" {
            let weightDouble = Double(weight)
            if kilogramButton.titleLabel?.text == "lbs" {
                weightInKg = weightDouble! *  0.45359237
            } else {
                weightInKg = weightDouble!
            }
        }
        
        userDocRef.updateData([
            "firstName": firstNameTextField.text ?? "",
            "lastName": lastNameTextField.text ?? "",
            "dateOfBirth": dateOfBirthTextField.text ?? "",
            "weightInKg": weightInKg,
            "male": male ?? ""
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    @IBAction func firstNameEditingChanged(_ sender: Any) {
        guard firstNameTextField.text != "" else {
            firstNameTextField.alpha = 0.5
            return
        }
        firstNameTextField.alpha = 1
    }
    
    @IBAction func lastNameEditingChanged(_ sender: Any) {
        guard lastNameTextField.text != "" else {
            lastNameTextField.alpha = 0.5
            return
        }
        lastNameTextField.alpha = 1
    }
    
    @IBAction func dateOfBirthEditingChanged(_ sender: Any) {
        guard dateOfBirthTextField.text != "" else {
            dateOfBirthTextField.alpha = 0.5
            return
        }
        dateOfBirthTextField.alpha = 1
    }
    
    @IBAction func weightEditingChanged(_ sender: Any) {
        guard weightTextField.text != "" else {
            weightTextField.alpha = 0.5
            return
        }
        weightTextField.alpha = 1
    }
    
    @IBAction func kilogramButtonClicked(_ sender: Any) {
        if kilogramButton.titleLabel?.text == "kg" {
            kilogramButton.setTitle("lbs", for: .normal)
        } else {
            kilogramButton.setTitle("kg", for: .normal)
        }
    }
    
    // MARK: - Picker functions
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        dateOfBirthTextField.text = selectedDate
        dateOfBirthTextField.alpha = 1
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
