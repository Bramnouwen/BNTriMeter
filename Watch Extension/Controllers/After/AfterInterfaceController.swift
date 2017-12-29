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
    
    @IBOutlet var goalIcon: WKInterfaceImage!
    @IBOutlet var goalAmountLabel: WKInterfaceLabel!
    @IBOutlet var goalAmountDescriptionLabel: WKInterfaceLabel!
    
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
    
    @IBAction func saveButtonClicked() {
        save(wm.workoutSession!)
    }
    
    @IBAction func discardButtonClicked() {
        // TODO: Show alert for confirmation
        WKInterfaceController.reloadRootControllers(withNamesAndContexts: [("ActivityController", 1 as AnyObject)])
    }
    
    func save(_ workoutSession: HKWorkoutSession) {
        let config = workoutSession.workoutConfiguration
        let workout = HKWorkout(activityType: config.activityType,
                                start: wm.workoutStartDate,
                                end: wm.workoutEndDate,
                                workoutEvents: nil,
                                totalEnergyBurned: wm.totalEnergyBurned,
                                totalDistance: wm.totalDistance,
                                metadata: [HKMetadataKeyIndoorWorkout: false])
        
        wm.healthStore?.save(workout) { (success, error) in
            if success {
                WKInterfaceController.reloadRootControllers(withNamesAndContexts: [("ActivityController", 1 as AnyObject)])
            }
        }
    }
}
