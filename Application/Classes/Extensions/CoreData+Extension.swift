//
//  CoreData+Extension.swift
//  TriMeter
//
//  Created by Bram Nouwen on 10/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit

extension TMActivity {
    func convert() -> Activity {
        var newGoal: Goal?
        if let goal = goal {
            newGoal = goal.convert()
        }
        
        var newData: DataLayout?
        if let dataLayout = dataLayout {
            newData = dataLayout.convert()
        }
        
        var newSettings: SettingsLayout?
        if let settingsLayout = settingsLayout {
            newSettings = settingsLayout.convert()
        }
        
        var newParts: [Activity]?
        if let parts = parts {
            newParts = convertTMParts(parts)
        }
        
        let convertedActivity = Activity(tableViewId: Int(tableViewId),
                                         title: title!,
                                         iconName: iconName!,
                                         goal: newGoal,
                                         dataLayout: newData,
                                         settingsLayout: newSettings,
                                         isPartOfWorkout: isPartOfWorkout,
                                         partId: Int(partId),
                                         parts: newParts)
        
        return convertedActivity
    }
    
    func convertTMParts(_ parts: NSSet) -> [Activity] {
        let partsSet = parts.allObjects as! [TMActivity]
        var activities: [Activity] = []
        for activity in partsSet {
            activities.append(Activity(tableViewId: Int(activity.tableViewId),
                                       title: activity.title!,
                                       iconName: activity.iconName!,
                                       goal: activity.goal?.convert(),
                                       dataLayout: activity.dataLayout?.convert(),
                                       settingsLayout: activity.settingsLayout?.convert(),
                                       isPartOfWorkout: activity.isPartOfWorkout,
                                       partId: Int(activity.partId),
                                       parts: convertTMParts(activity.parts!)))
        }
        
        return activities
    }
}

extension TMGoal {
    func convert() -> Goal {
        let convertedGoal = Goal(id: Int(id),
                                 title: title!,
                                 iconName: iconName!,
                                 descriptionString: descriptionString!,
                                 amount: Int(amount))
        
        return convertedGoal
    }
}

extension TMData {
    func convert() -> DataField {
        let convertedData = DataField(id: Int(id),
                                      title: title!,
                                      iconString: iconString!,
                                      descriptionString: descriptionString!,
                                      amountString: amountString!,
                                      spot: Int(spot))
        
        return convertedData
    }
}

extension TMDataLayout {
    func convert() -> DataLayout {
        let dataSet = data?.allObjects as! [TMData]
        var dataFields: [DataField] = []
        for data in dataSet {
            dataFields.append(data.convert())
        }
        let convertedDataLayout = DataLayout(dataFields: dataFields)
        
        return convertedDataLayout
    }
}

extension TMSettingsLayout {
    func convert() -> SettingsLayout {
        let convertedSettingsLayout = SettingsLayout(audio: audio,
                                                     autopause: autopause,
                                                     countdown: countdown,
                                                     countdownAmount: Int(countdownAmount),
                                                     haptic: haptic,
                                                     liveLocation: liveLocation)
        
        return convertedSettingsLayout
    }
}
