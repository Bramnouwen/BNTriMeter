//
//  OverviewTransitionRowController.swift
//  Watch Extension
//
//  Created by Bram Nouwen on 23/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import WatchKit

class OverviewTransitionRowController: NSObject {

    @IBOutlet var titleLabel: WKInterfaceLabel!
    
    var part: Activity? {
        didSet {
            guard let part = part else { return }
            titleLabel.setText(part.title)
            
            titleLabel.setTextColor(Colors.bermuda)
        }
    }
}
