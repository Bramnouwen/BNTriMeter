//
//  ActivityRowController.swift
//  Watch Extension
//
//  Created by Bram Nouwen on 21/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import Foundation
import WatchKit

protocol ActivityDelegate {
    func presentGoalScreen(_ activity: Activity)
    func presentOverview(_ activity: Activity)
}

class ActivityRowController: NSObject {
    
    var delegate: ActivityDelegate?
    
    @IBOutlet var noGoalButton: WKInterfaceButton!
    @IBOutlet var activityIcon: WKInterfaceImage!
    @IBOutlet var activitytitle: WKInterfaceLabel!
    @IBOutlet var noGoalLabel: WKInterfaceLabel!
    
    @IBOutlet var goalsGroup: WKInterfaceGroup!
    
    @IBOutlet var durationButton: WKInterfaceButton!
    @IBOutlet var durationIcon: WKInterfaceImage!
    @IBOutlet var durationLabel: WKInterfaceLabel!
    
    @IBOutlet var distanceButton: WKInterfaceButton!
    @IBOutlet var distanceIcon: WKInterfaceImage!
    @IBOutlet var distanceLabel: WKInterfaceLabel!
    
    @IBOutlet var paceButton: WKInterfaceButton!
    @IBOutlet var paceIcon: WKInterfaceImage!
    @IBOutlet var paceLabel: WKInterfaceLabel!
    
    @IBOutlet var caloriesButton: WKInterfaceButton!
    @IBOutlet var caloriesIcon: WKInterfaceImage!
    @IBOutlet var caloriesLabel: WKInterfaceLabel!
    
    @IBOutlet var separator: WKInterfaceSeparator!
    
    var activity: Activity? {
        didSet {
            guard let activity = activity else { return }
            
            let iconGreen = "\(activity.iconName!)-green"
            activityIcon.setImageNamed(iconGreen)
            activitytitle.setText(activity.title)
            
            if activity.isPreset {
                noGoalLabel.setText(L10n.Choose.Obstruction.toOverview)
                goalsGroup.setHidden(true)
            } else {
                noGoalLabel.setText(L10n.Watch.Nogoal.description)
                goalsGroup.setHidden(false)
            }
            durationLabel.setText(L10n.Goal.Duration.title)
            distanceLabel.setText(L10n.Goal.Distance.title)
            paceLabel.setText(L10n.Goal.Pace.title)
            caloriesLabel.setText(L10n.Goal.Calories.title)
        }
    }
    
    override init() {
        super.init()
        
        
    }
    
    @IBAction func noGoalClicked() {
        print("Goal clicked from activity with tableViewId: \(activity!.tableViewId!)")
        guard let activity = activity else { return }
        activity.goal = setGoal(id: 4, title: L10n.Goal.Nothing.title, iconName: "nothing")
        if activity.isPreset {
            delegate?.presentOverview(activity)
        } else {
            delegate?.presentGoalScreen(activity)
        }
    }
    
    /*
     var id: Int
     var title: String
     var iconName: String
     var descriptionString: String
     var amount: Int
     */
    @IBAction func durationClicked() {
        print("Duration clicked from activity with tableViewId: \(activity!.tableViewId!)")
        guard let activity = activity else { return }
        activity.goal = setGoal(id: 0, title: L10n.Goal.Duration.title, iconName: "duration")
        delegate?.presentGoalScreen(activity)
    }
    
    @IBAction func distanceClicked() {
        print("Distance clicked from activity with tableViewId: \(activity!.tableViewId!)")
        guard let activity = activity else { return }
        activity.goal = setGoal(id: 2, title: L10n.Goal.Distance.title, iconName: "distance")
        delegate?.presentGoalScreen(activity)
    }
    
    @IBAction func paceClicked() {
        print("Pace clicked from activity with tableViewId: \(activity!.tableViewId!)")
        guard let activity = activity else { return }
        activity.goal = setGoal(id: 1, title: L10n.Goal.Pace.title, iconName: "pace")
        delegate?.presentGoalScreen(activity)
    }
    
    @IBAction func caloriesClicked() {
        print("Calories clicked from activity with tableViewId: \(activity!.tableViewId!)")
        guard let activity = activity else { return }
        activity.goal = setGoal(id: 3, title: L10n.Goal.Calories.title, iconName: "calories")
        delegate?.presentGoalScreen(activity)
    }
    
    func setGoal(id: Int, title: String, iconName: String) -> Goal {
        return Goal(id: id, title: title, iconName: iconName)
    }
    
}
