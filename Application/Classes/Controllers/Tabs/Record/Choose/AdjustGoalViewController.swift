//
//  AdjustGoalViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 7/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//
/* Referenced
 - https://stackoverflow.com/questions/44017576/how-do-i-change-the-font-color-of-uipickerview-and-uidatepicker
 
 */

import UIKit
import IBAnimatable
import IQKeyboardManager

class AdjustGoalViewController: GradientViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let dataManager = DataManager.shared
    let defaults = UserDefaults.standard
    
    var goalId: Int!
    
    // Strings
    var goalString = ""
    var goalDescriptionString = ""
    var descriptionString = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var goalAmount: UILabel!
    @IBOutlet weak var goalDescription: UILabel!
    
    var buttonAmount: Int = 0
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var doneButton: AnimatableButton!
    
    var pickerComponents = 1
    var onePickerOption: [Int] = []
    var twoPickerOptions: [[Int]] = []
    var twoPickersStringOne = "0"
    var twoPickersStringTwo = "0"
    
    @IBOutlet weak var IBPickerView: UIPickerView!
    
    var newAmount: Int = 0 {
        didSet {
            dataManager.currentActivity.goal?.amount = newAmount
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor(named: "Bermuda")
        
        // TODO: change goal amounts to something else, like last goal, total average, ...
        switch goalId {
        case 0:
            goalString = L10n.Data.Duration.total
            buttonAmount = 60 //seconds
            descriptionString = L10n.Adjust.Goal.description("1")
            newAmount = defaults.integer(forKey: "previousDuration")
            goalDescriptionString = L10n.Adjust.duration
            setDurationPickerOptions()
        case 1:
            goalString = L10n.Data.Pace.current
            buttonAmount = 1 //second
            descriptionString = L10n.Adjust.Goal.description("0.01")
            newAmount = defaults.integer(forKey: "previousPace")
            goalDescriptionString = L10n.Adjust.pace
            setPacePickerOptions()
        case 2:
            goalString = L10n.Data.Distance.total
            buttonAmount = 100 //meter
            descriptionString = L10n.Adjust.Goal.description("0.10")
            newAmount = defaults.integer(forKey: "previousDistance")
            goalDescriptionString = L10n.Adjust.distance
            setDistancePickerOptions()
        case 3:
            goalString = L10n.Data.Calories.total
            buttonAmount = 5 //calories
            descriptionString = L10n.Adjust.Goal.description("5")
            newAmount = defaults.integer(forKey: "previousCalories")
            goalDescriptionString = L10n.Adjust.calories
            setCaloriesPickerOptions()
        default:
            print("We shouldn't be here (adjusting goal)")
        }

        let coloredAttributes = [NSAttributedStringKey.font: UIFont(name: "Cabin-Bold", size: 18)!,
                                 NSAttributedStringKey.foregroundColor: UIColor(named: "Bermuda")!]
        
        let descriptionText = NSMutableAttributedString(string: L10n.Adjust.Goal.Title.one)
        descriptionText.append(NSMutableAttributedString(string: goalString.lowercased(), attributes: coloredAttributes))
        descriptionText.append(NSMutableAttributedString(string: L10n.Adjust.Goal.Title.two))
        descriptionText.append(NSMutableAttributedString(string: dataManager.currentActivity.title.lowercased(), attributes: coloredAttributes))
        descriptionText.append(NSMutableAttributedString(string: L10n.Adjust.Goal.Title.three))

        titleLabel.attributedText = descriptionText
        descriptionLabel.text = descriptionString
        
        goalTitle.text = goalString
        goalAmount.text = dataManager.currentActivity.goal?.amountNoString()
        goalDescription.text = goalDescriptionString
        
        doneButton.setTitle(L10n.Common.done, for: .normal)
        
        // Set up pickerview
        IBPickerView.delegate = self
        IBPickerView.dataSource = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        switch goalId! {
        case 0:
            defaults.setValue(newAmount, forKey: "previousDuration")
        case 1:
            defaults.setValue(newAmount, forKey: "previousPace")
        case 2:
            defaults.setValue(newAmount, forKey: "previousDistance")
        case 3:
            defaults.setValue(newAmount, forKey: "previousCalories")
        default:
            return print("We shouldn't be here.")
        }
    }
    
    @IBAction func minusButtonClicked(_ sender: Any) {
        newAmount -= buttonAmount
        dataManager.currentActivity.goal?.amount = newAmount
        goalAmount.text = dataManager.currentActivity.goal?.amountNoString()
    }
    
    @IBAction func plusButtonClicked(_ sender: Any) {
        newAmount += buttonAmount
        dataManager.currentActivity.goal?.amount = newAmount
        goalAmount.text = dataManager.currentActivity.goal?.amountNoString()
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Picker functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerComponents == 1 {
            return onePickerOption.count
        }
        
        return twoPickerOptions[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerComponents == 1 {
            goalAmount.text = "\(onePickerOption[row])"
        } else {
            if component == 0 {
                twoPickersStringOne = "\(twoPickerOptions[component][row])"
            } else {
                twoPickersStringTwo = "\(twoPickerOptions[component][row])"
            }
            goalAmount.text = "\(twoPickersStringOne):\(twoPickersStringTwo)"
        }
        
        setNewAmount()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerComponents == 1 {
            return NSAttributedString(string: "\(onePickerOption[row])", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        }
        return NSAttributedString(string: "\(twoPickerOptions[component][row])", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    
    // Calculate goal
    
    func setNewAmount() {
        guard let amountString = goalAmount.text else { return }
        switch goalId! {
        case 0:
            newAmount = Int(amountString)! * 60
        case 1:
            let splitString = amountString.split(separator: ":", maxSplits: 2, omittingEmptySubsequences: true)
            let min = Int(splitString[0])
            let sec = Int(splitString[1])
            newAmount = (min! * 60) + sec!
        case 2:
            newAmount = Int(amountString)! * 1000
        case 3:
            newAmount = Int(amountString)!
        default:
            return print("We shouldn't be here")
        }
        dataManager.currentActivity.goal?.amount = newAmount
    }
    
    // Picker options
    
    func setDurationPickerOptions() {
        pickerComponents = 1
        for i in 1...24 {
            onePickerOption.append(i * 5)
        }
    }
    
    func setPacePickerOptions() {
        pickerComponents = 2
        var pickerOne: [Int] = []
        var pickerTwo: [Int] = []
        for i in 1...20 {
            pickerOne.append(i)
        }
        for i in 0...5 {
            pickerTwo.append(i * 10)
        }
        twoPickerOptions = [pickerOne, pickerTwo]
    }
    
    func setDistancePickerOptions() {
        pickerComponents = 1
        for i in 1...1000 {
            onePickerOption.append(i)
        }
    }
    
    func setCaloriesPickerOptions() {
        pickerComponents = 1
        for i in 1...100 {
            onePickerOption.append(i * 25)
        }
    }

}