//
//  GoalController.swift
//  Watch Extension
//
//  Created by Bram Nouwen on 22/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import WatchKit
import HealthKit

class GoalInterfaceController: WKInterfaceController {
    
    let wm = WorkoutManager.shared
    
    var goalId: Int!
    
    var goalString = ""
    var goalDescriptionString = ""
    var descriptionString = ""
    
    @IBOutlet var descriptionLabel: WKInterfaceLabel!
    @IBOutlet var goalTitle: WKInterfaceLabel!
    @IBOutlet var goalAmount: WKInterfaceLabel!
    @IBOutlet var goalDescription: WKInterfaceLabel!
    
    @IBOutlet var startButton: WKInterfaceButton!
    
    var scrollAmount: Int = 0
    var buttonAmount: Int = 0
    @IBOutlet var minusButton: WKInterfaceButton!
    @IBOutlet var plusButton: WKInterfaceButton!
    
    var crownAccumulator = 0.0
    var newAmount = 0 {
        didSet {
            goalAmount.setText(returnAmountAsString(amount: newAmount))
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("Awake")
        
        goalId = wm.activity?.goal?.id
        
        startButton.setTitle(L10n.Tabs.start)
        
        crownSequencer.delegate = self
        
        switch goalId {
        case 0:
            goalString = L10n.Data.Duration.total
            buttonAmount = 60 //seconds
            scrollAmount = 60 * 5
            descriptionString = L10n.Watch.Goal.description("1", "5")
//            newAmount = defaults.integer(forKey: "previousDuration")
            goalDescriptionString = L10n.Adjust.duration
        case 1:
            goalString = L10n.Data.Pace.current
            buttonAmount = 60 //second
            scrollAmount = 1
            descriptionString = L10n.Watch.Goal.description("1", "0:01")
//            newAmount = defaults.integer(forKey: "previousPace")
            goalDescriptionString = L10n.Adjust.pace
        case 2:
            goalString = L10n.Data.Distance.total
            buttonAmount = 100 //meter
            scrollAmount = 1000
            descriptionString = L10n.Watch.Goal.description("0.1", "1")
//            newAmount = defaults.integer(forKey: "previousDistance")
            goalDescriptionString = L10n.Adjust.distance
        case 3:
            goalString = L10n.Data.Calories.total
            buttonAmount = 5 //calories
            scrollAmount = 25
            descriptionString = L10n.Watch.Goal.description("5", "25")
//            newAmount = defaults.integer(forKey: "previousCalories")
            goalDescriptionString = L10n.Adjust.calories
        case 4:
            goalString = "No goal"
        default: // Countdown
            goalString = L10n.Adjust.Countdown.Title.two
            buttonAmount = 1 //second
            descriptionString = L10n.Adjust.Countdown.description
//            newAmount = defaults.integer(forKey: "previousCountdown")
            goalDescriptionString = L10n.Adjust.countdown
        }
        
        switch goalId {
        case 4:
            descriptionLabel.setHidden(true)
            
            goalTitle.setText(goalString)
            goalAmount.setText("open")
            goalDescription.setHidden(true)
            
            plusButton.setHidden(true)
            minusButton.setHidden(true)
        default:
            descriptionLabel.setText(descriptionString)
            
            goalTitle.setText(goalString)
            goalAmount.setText("\(newAmount)")
            goalDescription.setText(goalDescriptionString)
        }
        
        
    }
    
    override func willActivate() {
        super.willActivate()
        print("Will activate")
        
        crownSequencer.focus()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        print("Did deactivate")
    }
    
    
    
    @IBAction func minusButtonClicked() {
        guard goalId != 4 else { return }
        guard newAmount > 0 else { return }
        newAmount -= buttonAmount
        wm.activity?.goal?.amount = newAmount
    }
    
    @IBAction func plusButtonClicked() {
        guard goalId != 4 else { return }
        newAmount += buttonAmount
        wm.activity?.goal?.amount = newAmount
    }
    
    @IBAction func startButtonClicked() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        wm.startWorkout(nil)
        
    }
}

extension GoalInterfaceController: WKCrownDelegate {
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        print("Crown did become idle")
        guard goalId != 4 else { return }
        wm.activity?.goal?.amount = newAmount
    }
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        print("Crown did rotate: \(rotationalDelta)")
        guard goalId != 4 else { return }
        crownAccumulator += rotationalDelta
        
        if crownAccumulator > 0.1 {
            crownAccumulator = 0.0
            newAmount += scrollAmount
        } else if crownAccumulator < -0.1 {
            crownAccumulator = 0.0
            guard newAmount > 0 else { return }
            newAmount -= scrollAmount
        }
    }
    
    func returnAmountAsString(amount: Int) -> String {
        switch goalId {
        case 0:
            return "\(amount / 60)"
        case 1:
            let min = Int(floor(Double(amount / 60)))
            let sec = amount % 60
            return "\(min):\(sec)"
        case 2:
            return "\(Float(amount) / 1000)"
        case 3:
            return "\(amount)"
        default:
            return L10n.Goal.Nothing.amount
        }
    }
}
