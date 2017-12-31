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
    
    @IBOutlet var saveButton: WKInterfaceButton!
    @IBOutlet var discardButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("Awake")
        
        setTitle("Overzicht")
        
        guard let activity = wm.activity else { return }
        setGoal(goalID: activity.goal!.id)
        
        workout = wm.createHKWorkout()
        guard workout != nil else { return }
        setSummary(with: workout!)
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
    }
    
    @IBAction func saveButtonClicked() {
        guard workout != nil else { return }
        wm.save(workout: workout!)
    }
    
    @IBAction func discardButtonClicked() {
        // TODO: Show alert for confirmation
        DispatchQueue.main.async {
            WKInterfaceController.reloadRootControllers(withNamesAndContexts: [("ActivityController", 1 as AnyObject)])
        }
    }
    
}
