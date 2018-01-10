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
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("Awake")
        
        var activityType: HKWorkoutActivityType?
        
        if let activity = wm.activity {
            if !activity.isPreset {
                setTitle(activity.title)
                activityType = activity.healthKitWorkoutActivityType()
            } else if let parts = activity.parts {
                let currentPart = parts[wm.currentPart]
                setTitle(currentPart.title)
                activityType = currentPart.healthKitWorkoutActivityType()
            }
        }
        
        if let type = activityType, type != .walking || type != .running {
            dataGroup5.setHidden(true)
        }
        
        // Notification listener
        NotificationCenter.default.addObserver(self, selector: #selector(DuringInterfaceController.updateLabels), name: NSNotification.Name(rawValue: "updateLabels"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DuringInterfaceController.startTimer), name:
            NSNotification.Name(rawValue: "startTimer"), object: nil)
        updateLabels()
        startTimer()
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
        dataAdjLabel2.setText("km")
        
        // Calories
        let kiloCalories = wm.totalEnergyBurned.doubleValue(for: HKUnit.kilocalorie())
        dataLabel3.setText(format(totalEnergyBurned: kiloCalories))
        dataAdjLabel3.setText("kcal")
        
        // HeartRate
        let heartRate = Int(wm.lastHeartRate)
        dataLabel4.setText(format(lastHeartRate: heartRate))
        dataAdjLabel4.setText("spm")
        
        // Steps
        let steps = wm.totalSteps.doubleValue(for: HKUnit.count())
        dataLabel5.setText(format(totalSteps: steps))
        dataAdjLabel5.setText("stappen")
    }
    
    
}

