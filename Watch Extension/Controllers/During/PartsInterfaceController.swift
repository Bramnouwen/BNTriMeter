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
        
        guard let activity = wm.activity, let parts = activity.parts else { return }
        
        let currentPart = parts[wm.currentPart]
        setTitle(currentPart.title)
        if let currentGoal = currentPart.goal {
            //Goal exists
            currentGoalIcon.setImageNamed(currentPart.iconName)
            currentGoalAmountLabel.setText(currentGoal.amountNoString())
            currentGoalAdjLabel.setText(getGoalDescriptionString(goalID: currentGoal.id))
        } else {
            //Goal doesn't exist so this should be a transition
            currentGoalIcon.setHidden(true)
            currentGoalAmountLabel.setText("T")
            currentGoalAmountLabel.setTextColor(Colors.bermuda)
            currentGoalAdjLabel.setHidden(true)
        }
        
        if parts.indices.contains(wm.currentPart + 1) {
            //Next part exists
            if let nextGoal = parts[wm.currentPart + 1].goal {
                //Next goal exists
                nextGoalIcon.setImageNamed(parts[wm.currentPart + 1].iconName)
                nextGoalAmountLabel.setText(nextGoal.amountNoString())
                nextGoalAdjLabel.setText(getGoalDescriptionString(goalID: nextGoal.id))
            } else {
                //Goal doesn't exist so this should be a transition
                nextGoalIcon.setHidden(true)
                nextGoalAmountLabel.setText("T")
                nextGoalAmountLabel.setTextColor(Colors.bermuda)
                nextGoalAdjLabel.setHidden(true)
            }
        } else {
            //Next part doesn't exists, finishing after this
            nextGoalIcon.setImageNamed("finishFlag")
            nextGoalAmountLabel.setText("Finish")
            nextGoalAdjLabel.setHidden(true)
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
    
    func getGoalDescriptionString(goalID: Int) -> String {
        switch goalID {
        case 0:
            return L10n.Adjust.duration
        case 1:
            return L10n.Adjust.pace
        case 2:
            return L10n.Adjust.distance
        case 3:
            return L10n.Adjust.calories
        case 4:
            return "Open"
        default:
            return ""
        }
        
    }
}
