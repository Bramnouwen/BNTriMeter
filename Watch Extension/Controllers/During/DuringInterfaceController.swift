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
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("Awake")
        
        // Notification listener
        NotificationCenter.default.addObserver(self, selector: #selector(DuringInterfaceController.updateLabels), name: NSNotification.Name(rawValue: "updateDataLabels"), object: nil)
        
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
    
    @objc
    func updateLabels() {
        
        // Distance
        let meters = wm.totalDistance.doubleValue(for: HKUnit.meter())
        let kilometers = meters / 1000
        let formattedKilometers = String(format: "%.2f", kilometers)
        dataLabel2.setText(formattedKilometers)
        dataAdjLabel2.setText("km")
        
        // Calories
        let kiloCalories = wm.totalEnergyBurned.doubleValue(for: HKUnit.kilocalorie())
        let formattedKiloCalories = String(format: "%.f", kiloCalories)
        dataLabel3.setText(formattedKiloCalories)
        dataAdjLabel3.setText("kcal")
        
        // HeartRate
        let heartRate = String(Int(wm.lastHeartRate))
        dataLabel4.setText(heartRate)
        dataAdjLabel4.setText("spm")
        
        // Steps
        let steps = wm.totalSteps.doubleValue(for: HKUnit.count())
        let formattedSteps = String(format: "%d", steps)
        dataLabel5.setText(formattedSteps)
        dataAdjLabel5.setText("stappen")
    }
    
    
//    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
//        return self.activity
//    }
}

