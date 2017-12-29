//
//  PartsInterfaceController.swift
//  Watch Extension
//
//  Created by Bram Nouwen on 28/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import WatchKit

class PartsInterfaceController: WKInterfaceController {

    let wm = WorkoutManager.shared
    
    @IBOutlet var currentLabel: WKInterfaceLabel!
    @IBOutlet var currentGoalIcon: WKInterfaceImage!
    @IBOutlet var currentGoalAmountLabel: WKInterfaceLabel!
    @IBOutlet var currentGoalAdjLabel: WKInterfaceLabel!
    
    @IBOutlet var nextLabel: WKInterfaceLabel!
    @IBOutlet var nextGoalIcon: WKInterfaceImage!
    @IBOutlet var nextGoalAmountLabel: WKInterfaceLabel!
    @IBOutlet var nextGoalAdjLabel: WKInterfaceLabel!
    
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
    
//    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
//        return activity
//    }
}
