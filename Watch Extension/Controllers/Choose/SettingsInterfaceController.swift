//
//  SettingsInterfaceController.swift
//  Watch Extension
//
//  Created by Bram Nouwen on 22/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import WatchKit

class SettingsInterfaceController: WKInterfaceController {

    let wm = WorkoutManager.shared
    
    var goalId: Int!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("Awake")
        
        goalId = wm.activity?.goal?.id
        
        
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
//        return wm.activity
//    }
}
