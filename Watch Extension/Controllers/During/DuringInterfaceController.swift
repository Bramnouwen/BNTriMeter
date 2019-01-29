//
//  DuringInterfaceController.swift
//  Watch Extension
//
//  Created by Bram Nouwen on 28/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import WatchKit
import HealthKit

class DuringInterfaceController: WKInterfaceController {

    let wm = WorkoutManager.shared
    
    @IBOutlet var dataGroup: WKInterfaceGroup!
    
    @IBOutlet var dataGroup1: WKInterfaceGroup!
    @IBOutlet var dataLabel1: WKInterfaceLabel!
    @IBOutlet var dataAdjLabel1: WKInterfaceLabel!
    
    @IBOutlet var dataGroup2: WKInterfaceGroup!
    @IBOutlet var dataLabel2: WKInterfaceLabel!
    @IBOutlet var dataAdjLabel2: WKInterfaceLabel!
    
    @IBOutlet var dataGroup3: WKInterfaceGroup!
    @IBOutlet var dataLabel3: WKInterfaceLabel!
    @IBOutlet var dataAdjLabel3: WKInterfaceLabel!
    
    @IBOutlet var dataGroup4: WKInterfaceGroup!
    @IBOutlet var dataLabel4: WKInterfaceLabel!
    @IBOutlet var dataAdjLabel4: WKInterfaceLabel!
    
    @IBOutlet var dataGroup5: WKInterfaceGroup!
    @IBOutlet var dataLabel5: WKInterfaceLabel!
    @IBOutlet var dataAdjLabel5: WKInterfaceLabel!
    
    var durationString = ""
    
    var activityType: HKWorkoutActivityType!
    
    //Goal
    @IBOutlet var goalGroup: WKInterfaceGroup!
    @IBOutlet var goalIcon: WKInterfaceImage!
    @IBOutlet var goalAmountLabel: WKInterfaceLabel!
    @IBOutlet var goalDescriptionLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("Awake")
        
        if let activity = wm.activity {
            if !activity.isPreset {
                setTitle(activity.title)
                activityType = activity.healthKitWorkoutActivityType()
                setGoal(activity: activity)
            } else if let parts = activity.parts {
                let currentPart = parts[wm.currentPart]
                setTitle(currentPart.title)
                activityType = currentPart.healthKitWorkoutActivityType()
                setGoal(activity: currentPart)
            }
        }
        
        hideElements() //after setting activity type
        
        // Notification listener
        NotificationCenter.default.addObserver(self, selector: #selector(DuringInterfaceController.updateLabels), name: NSNotification.Name(rawValue: "updateLabels"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DuringInterfaceController.startTimer), name:
            NSNotification.Name(rawValue: "startTimer"), object: nil)
        
        updateLabels()
        startTimer()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.dataGroup.setHidden(false)
            self.goalGroup.setHidden(true)
        }
    }
    
    override func willActivate() {
        super.willActivate()
        print("Will activate")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        print("Did deactivate")
        print("In did deactivate for Apple Watch: DuringInterfaceController")
        
    }
    
    // Hide necessary elements
    func hideElements() {
        if activityType == .swimming || activityType == .cycling {
            print("We are swimming or cycling, no need to count or show steps")
            dataGroup5.setHidden(true)
        }
        dataGroup.setHidden(true)
        goalGroup.setHidden(false)
        
    }
    
    // MARK: - Timer
    @objc
    func startTimer() {
        wm.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.durationString = format(totalDuration: calculateTimeIntervalBetween(startDate: self.wm.workoutStartDate + self.wm.cumulativePauseTime, endDate: self.wm.workoutEndDate))
            self.updateLabels()
        }
    }
    
    @objc
    func updateLabels() {
        dataLabel1.setText(durationString)

        // Distance
        let meters = wm.totalDistance.doubleValue(for: HKUnit.meter())
        dataLabel2.setText(format(totalDistance: meters))
        dataAdjLabel2.setText("km") //TODO: Localize

        // Calories
        let kiloCalories = wm.totalEnergyBurned.doubleValue(for: HKUnit.kilocalorie())
        dataLabel3.setText(format(totalEnergyBurned: kiloCalories))
        dataAdjLabel3.setText("kcal") //TODO: Localize

        // HeartRate
        let heartRate = Int(wm.lastHeartRate)
        dataLabel4.setText(format(lastHeartRate: heartRate))
        dataAdjLabel4.setText("bpm") //TODO: Localize

        // Steps
        let steps = wm.totalSteps.doubleValue(for: HKUnit.count())
        dataLabel5.setText(format(totalSteps: steps))
        dataAdjLabel5.setText("steps") //TODO: Localize
    }
    
    func setGoal(activity: Activity) {
        var goalID = 5
        if activity.goal != nil {
            goalID = activity.goal!.id
        }
        var goalDescriptionString = ""
        
        switch goalID {
        case 0:
            goalDescriptionString = L10n.Adjust.duration
        case 1:
            goalDescriptionString = L10n.Adjust.pace
        case 2:
            goalDescriptionString = L10n.Adjust.distance
        case 3:
            goalDescriptionString = L10n.Adjust.calories
        case 4:
            goalDescriptionString = "Open"
        default:
            break
        }
        
        goalIcon.setImageNamed(activity.iconName)
        if goalID != 4 {
            goalAmountLabel.setText(activity.goal?.amountNoString())
            goalDescriptionLabel.setText(goalDescriptionString)
        } else {
            goalAmountLabel.setText(goalDescriptionString)
            goalDescriptionLabel.setHidden(true)
        }
        switch goalID {
        case 0, 1, 2, 3:
            goalAmountLabel.setText(activity.goal?.amountNoString())
            goalDescriptionLabel.setText(goalDescriptionString)
        case 4:
            goalAmountLabel.setText(goalDescriptionString)
            goalDescriptionLabel.setHidden(true)
        case 5:
            goalIcon.setHidden(true)
            goalDescriptionLabel.setHidden(true)
            goalAmountLabel.setText(L10n.Activity.Triathlon.transition)
        default: break
        }
    }
    
}

