//
//  Formatters.swift
//  TriMeter
//
//  Created by Bram Nouwen on 10/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit

class Formatters: NSObject {
    
    static let shared = Formatters()
    
    static let min0max2Formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    static let paceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
