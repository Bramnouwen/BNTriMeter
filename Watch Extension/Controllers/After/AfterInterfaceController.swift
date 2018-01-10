//
//  AfterInterfaceController.swift
//  Watch Extension
//
//  Created by Bram Nouwen on 28/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import WatchKit
import HealthKit

class AfterInterfaceController: WKInterfaceController {
    
    let wm = WorkoutManager.shared
    
    var workout: HKWorkout?
    
    @IBOutlet var goalIcon: WKInterfaceImage!
    @IBOutlet var goalAmountLabel: WKInterfaceLabel!
    @IBOutlet var goalAmountDescriptionLabel: WKInterfaceLabel!
    var goalDescriptionString = ""
    
    @IBOutlet var map: WKInterfaceMap!
    
    @IBOutlet var dataGroup1: WKInterfaceGroup!
    @IBOutlet var dataLabel1: WKInterfaceLabel!
    @IBOutlet var dataIcon1: WKInterfaceImage!
    
    @IBOutlet var dataGroup2: WKInterfaceGroup!
    @IBOutlet var dataLabel2: WKInterfaceLabel!
    @IBOutlet var dataIcon2: WKInterfaceImage!

    @IBOutlet var dataGroup3: WKInterfaceGroup!
    @IBOutlet var dataLabel3: WKInterfaceLabel!
    @IBOutlet var dataIcon3: WKInterfaceImage!

    @IBOutlet var dataGroup4: WKInterfaceGroup!
    @IBOutlet var dataLabel4: WKInterfaceLabel!
    @IBOutlet var dataIcon4: WKInterfaceImage!

    @IBOutlet var dataGroup5: WKInterfaceGroup!
    @IBOutlet var dataLabel5: WKInterfaceLabel!
    @IBOutlet var dataIcon5: WKInterfaceImage!
    
    @IBOutlet var dataGroup6: WKInterfaceGroup!
    @IBOutlet var dataLabel6: WKInterfaceLabel!
    @IBOutlet var dataIcon6: WKInterfaceImage!
    
    @IBOutlet var continueButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("Awake")
        wm.currentPart = 0 //reset current part counter
//        saveAllWorkouts()
        
        setTitle("Overzicht")
        
        guard let activity = wm.activity else { return }
        setGoal(goalID: activity.goal!.id)
        
        if activity.isTriathlon() {
            setTriathlonSummary(with: wm.workoutObjects)
        } else {
            guard let workoutObject = wm.workoutObject else { return }
            setSummary(with: workoutObject)
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
    }
    
    func setGoal(goalID: Int) {
        if wm.activity!.isTriathlon() {
            goalAmountLabel.setText(L10n.Activity.triathlon)
            goalAmountDescriptionLabel.setHidden(true)
            return
        }
        
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
        
        goalIcon.setImageNamed(wm.activity?.iconName)
        if goalID != 4 {
            goalAmountLabel.setText(wm.activity?.goal?.amountNoString())
            goalAmountDescriptionLabel.setText(goalDescriptionString)
        } else {
            goalAmountLabel.setText(goalDescriptionString)
            goalAmountDescriptionLabel.setHidden(true)
        }
    }
    
    func setSummary(with workout: HKWorkout) {
        dataLabel1.setText(format(totalDuration: workout.duration))
        
        dataLabel2.setText("\(format(totalDistance: workout.totalDistance)) km")
        
        dataLabel3.setText("\(format(totalEnergyBurned: workout.totalEnergyBurned)) kcal ")
        
        dataLabel4.setText("\(format(lastHeartRate: Int(wm.lastHeartRate)))") //get avg
        
        dataLabel5.setText("\(format(totalSteps: wm.totalSteps.doubleValue(for: HKUnit.count())))") //get total from workout object
        
        dataGroup6.setHidden(true)
    }
    
    func setTriathlonSummary(with workouts: [HKWorkout]) {
//        let indices = workouts.indices
        var totalDuration: TimeInterval = 0
        for workout in workouts {
            totalDuration += workout.duration
        }
        
        dataLabel1.setText(format(totalDuration: totalDuration))
        
        dataIcon2.setImageNamed("swimming")
        dataLabel2.setText(format(totalDuration: workouts[0].duration))
        
        dataIcon3.setImageNamed("transition")
        dataLabel3.setText(format(totalDuration: workouts[1].duration))
        
        dataIcon4.setImageNamed("cycling")
        dataLabel4.setText(format(totalDuration: workouts[2].duration))
        
        dataIcon5.setImageNamed("transition")
        dataLabel5.setText(format(totalDuration: workouts[3].duration))
        
        dataIcon6.setImageNamed("running")
        dataLabel6.setText(format(totalDuration: workouts[4].duration))
    }
    
    @IBAction func continueButtonClicked() {
        DispatchQueue.main.async {
            WKInterfaceController.reloadRootControllers(withNamesAndContexts: [("ActivityController", 1 as AnyObject)])
        }
    }
    
//    func saveAllWorkouts() {
//        for workout in wm.workoutObjects {
//            wm.save(workout: workout)
//        }
//    }
//    func addAllWorkoutObjects() {
//        var walkingDistance = HKQuantity(unit: HKUnit.meter(), doubleValue: 0)
//        var walkingEnergy = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 0)
//        var walkingSteps = HKQuantity(unit: HKUnit.count(), doubleValue: 0)
//        var walkingStartDate = Date()
//        var walkingEndDate = Date()
//
//        let workoutObjects = wm.workoutObjects
//
//        for w in workoutObjects {
//            if w.workoutActivityType == .walking {
//                walkingDistance = HKQuantity(unit: HKUnit.meter(), doubleValue: walkingDistance + w.totalDistance!)
//                walkingEnergy = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: walkingEnergy + w.totalEnergyBurned!)
//                walkingSteps = HKQuantity(unit: HKUnit.count(), doubleValue: walkingSteps + w.st)
//                if w.startDate < walkingStartDate {
//                    walkingStartDate = w.startDate
//                }
//                if w.endDate >
//            }
//        }
//    }
    
}















