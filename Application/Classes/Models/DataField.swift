//
//  dataField.swift
//  TriMeter
//
//  Created by Bram Nouwen on 7/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit

class DataField: NSObject, NSCoding {
    
    var id: Int
    var title: String
    var iconString: String
    var descriptionString: String
    var amountString: String
    var spot: Int
    
    
    init(id: Int,
         title: String,
         iconString: String,
         descriptionString: String,
         amountString: String,
         spot: Int) {
        
        self.id = id
        self.title = title
        self.iconString = iconString
        self.descriptionString = descriptionString
        self.amountString = amountString
        self.spot = spot
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(iconString, forKey: "iconString")
        aCoder.encode(descriptionString, forKey: "descriptionString")
        aCoder.encode(amountString, forKey: "amountString")
        aCoder.encode(spot, forKey: "spot")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let iconString = aDecoder.decodeObject(forKey: "iconString") as! String
        let descriptionString = aDecoder.decodeObject(forKey: "descriptionString") as! String
        let amountString = aDecoder.decodeObject(forKey: "amountString") as! String
        let spot = aDecoder.decodeInteger(forKey: "spot")
        
        self.init(id: id, title: title, iconString: iconString, descriptionString: descriptionString, amountString: amountString, spot: spot)
    }
}
