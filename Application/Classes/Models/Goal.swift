//
//  goal.swift
//  TriMeter
//
//  Created by Bram Nouwen on 7/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
class Goal: NSObject, NSCoding {
    
    let defaults = UserDefaults.standard
    
    var id: Int
    var title: String
    var iconName: String
    var descriptionString: String?
    var amount: Int?
    
    init(id: Int,
         title: String,
         iconName: String,
         descriptionString: String? = "",
         amount: Int? = 0) {
        
        self.id = id
        self.title = title
        self.iconName = iconName
        self.descriptionString = descriptionString
        self.amount = amount
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(iconName, forKey: "iconName")
        aCoder.encode(descriptionString, forKey: "descriptionString")
        aCoder.encode(amount, forKey: "amount")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let iconName = aDecoder.decodeObject(forKey: "iconName") as! String
        let descriptionString = aDecoder.decodeObject(forKey: "descriptionString") as? String
        let amount = aDecoder.decodeObject(forKey: "amount") as? Int
        
        self.init(id: id, title: title, iconName: iconName, descriptionString: descriptionString, amount: amount)
    }
    
}

extension Goal {
    func returnAmountString() -> String {
        switch id {
        case 0:
            let previousAmount = defaults.integer(forKey: "previousDuration")
            return L10n.Goal.Duration.amount(previousAmount)
        case 1:
            let previousAmount = defaults.integer(forKey: "previousPace")
            return L10n.Goal.Pace.amount(previousAmount)
        case 2:
            let previousAmount = defaults.integer(forKey: "previousDistance")
            return L10n.Goal.Distance.amount(previousAmount)
        case 3:
            let previousAmount = defaults.integer(forKey: "previousCalories")
            return L10n.Goal.Calories.amount(previousAmount)
        default:
            return L10n.Goal.Nothing.amount
        }
    }
    
    func previousAmountAsString() -> String {
        switch id {
        case 0:
            let previousAmount = defaults.integer(forKey: "previousDuration")
            return "\(previousAmount / 60) min"
        case 1:
            let previousAmount = defaults.integer(forKey: "previousPace")
            let min = Int(floor(Double(previousAmount / 60)))
            let sec = previousAmount % 60
            return "\(min):\(sec) min/km"
        case 2:
            let previousAmount = defaults.integer(forKey: "previousDistance")
            return "\(Float(previousAmount) / 1000) km"
        case 3:
            let previousAmount = defaults.integer(forKey: "previousCalories")
            return "\(previousAmount) kcal"
        default:
            return L10n.Goal.Nothing.amount
        }
    }
    
    func amountNoString() -> String {
        guard let amount = amount else { return "" }
        switch id {
        case 0:
            return "\(amount / 60)"
        case 1:
            let min = Int(floor(Double(amount / 60)))
            let sec = amount % 60
            return "\(min):\(sec)"
        case 2:
            return "\(Float(amount) / 1000)"
        case 3:
            return "\(amount)"
        default:
            return L10n.Goal.Nothing.amount
        }
    }
    
    func returnOverviewAmountString() -> String {
        guard let amount = amount else { return "" }
        switch id {
        case 0: // duration
            return "\(amount / 60) min"
        case 1: // pace
            let min = Int(floor(Double(amount / 60)))
            let sec = amount % 60
            return "\(min):\(sec) min/km"
        case 2: // distance
            if amount < 1000 {
                return "\(amount) m"
            } else {
                return "\(Float(amount) / 1000) km"
            }
        case 3: // calories
            return "\(amount) kcal"
        default:
            return L10n.Goal.Nothing.amount
        }
    }
}
