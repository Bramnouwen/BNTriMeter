//
//  dataLayout.swift
//  TriMeter
//
//  Created by Bram Nouwen on 7/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit

class DataLayout: NSObject, NSCoding {
    
    //var id: Int?
    //var defaultFor: Int?
    var dataFields: [DataField]
    
    init(dataFields: [DataField]) {
        self.dataFields = dataFields
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dataFields, forKey: "dataFields")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let dataFields = aDecoder.decodeObject(forKey: "dataFields") as! [DataField]
        
        self.init(dataFields: dataFields)
    }
    
}
