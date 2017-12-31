//
//  Activity.swift
//  TriMeter
//
//  Created by Bram Nouwen on 7/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import HealthKit

class Activity: NSObject, NSCoding {
        
    //var id: Int?
    var tableViewId: Int?
    var title: String
    var iconName: String?
    var goal: Goal?
    var goalSpeed: Int?
    var dataLayout: DataLayout?
    var settingsLayout: SettingsLayout?
    
    var isPartOfWorkout: Bool
    var isPreset: Bool
    var partId: Int?
    var parts: [Activity]?
    
    
    init(tableViewId: Int? = nil,
         title: String = "",
         iconName: String? = "saved",
         goal: Goal? = nil,
         goalSpeed: Int? = nil,
         dataLayout: DataLayout? = nil,
         settingsLayout: SettingsLayout? = nil,
         isPartOfWorkout: Bool = false,
         isPreset: Bool = false,
         partId: Int? = nil,
         parts: [Activity]? = []) {
        
        self.tableViewId = tableViewId
        self.title = title
        self.iconName = iconName
        self.goal = goal
        self.goalSpeed = goalSpeed
        self.dataLayout = dataLayout
        self.settingsLayout = settingsLayout
        self.isPartOfWorkout = isPartOfWorkout
        self.isPreset = isPreset
        self.partId = partId
        self.parts = parts
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(tableViewId, forKey: "tableViewId")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(iconName, forKey: "iconName")
        aCoder.encode(goal, forKey: "goal")
        aCoder.encode(goalSpeed, forKey: "goalSpeed")
        aCoder.encode(dataLayout, forKey: "dataLayout")
        aCoder.encode(settingsLayout, forKey: "settingsLayout")
        aCoder.encode(isPartOfWorkout, forKey: "isPartOfWorkout")
        aCoder.encode(isPreset, forKey: "isPreset")
        aCoder.encode(partId, forKey: "partId")
        aCoder.encode(parts, forKey: "parts")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let tableViewId = aDecoder.decodeObject(forKey: "tableViewId") as? Int
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let iconName = aDecoder.decodeObject(forKey: "iconName") as? String
        let goal = aDecoder.decodeObject(forKey: "goal") as? Goal
        let goalSpeed = aDecoder.decodeObject(forKey: "goalSpeed") as? Int
        let dataLayout = aDecoder.decodeObject(forKey: "dataLayout") as? DataLayout
        let settingsLayout = aDecoder.decodeObject(forKey: "settingsLayout") as? SettingsLayout
        let isPartOfWorkout = aDecoder.decodeBool(forKey: "isPartOfWorkout")
        let isPreset = aDecoder.decodeBool(forKey: "isPreset")
        let partId = aDecoder.decodeObject(forKey: "partId") as? Int
        let parts = aDecoder.decodeObject(forKey: "parts") as? [Activity]
        
        self.init(tableViewId: tableViewId, title: title, iconName: iconName, goal: goal, goalSpeed: goalSpeed, dataLayout: dataLayout, settingsLayout: settingsLayout, isPartOfWorkout: isPartOfWorkout, isPreset: isPreset, partId: partId, parts: parts)
    }
    
}

extension Activity {
    func getGoalString() -> String {
        if let goal = goal {
            return goal.previousAmountAsString()
        } else if title.contains(L10n.Activity.triathlon.lowercased()) == true {
            return L10n.Goal.triathlon
        } else if let parts = parts {
            if parts.count == 1 {
                return parts[0].getGoalString()
            } else {
                return L10n.Goal.multiple
            }
        } else {
            return L10n.Goal.Nothing.title
        }
    }
    
    func getGoalIconString() -> String {
        if let goal = goal {
            return goal.iconName
        } else if title.contains(L10n.Activity.triathlon.lowercased()) == true {
            return "finishFlag"
        } else if let parts = parts {
            if parts.count == 1 {
                return parts[0].getGoalIconString()
            } else {
                return "multipleGoals"
            }
        } else {
            return "nothing"
        }
    }
    
    func getOrderedData() -> [DataField] {
        if let dataSet = dataLayout?.dataFields, dataSet.count != 0 {
            let orderedData = dataSet.sorted(by: { $0.spot < $1.spot })
            return orderedData
        } else {
            let orderedParts = parts?.sorted(by: { $0.partId! < $1.partId! })
            let orderedData = orderedParts![0].dataLayout?.dataFields.sorted(by: { $0.spot < $1.spot })
            return orderedData!
        }
    }
    
    func healthKitWorkoutActivityType() -> HKWorkoutActivityType {
        switch title {
        case L10n.Activity.walking: return .walking
        case L10n.Activity.running: return .running
        case L10n.Activity.cycling: return .cycling
        case L10n.Activity.swimming: return .swimming
        default: return .running
        }
    }
}
