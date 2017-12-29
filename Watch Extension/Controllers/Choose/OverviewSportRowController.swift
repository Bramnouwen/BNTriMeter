//
//  OverviewSportRowController.swift
//  Watch Extension
//
//  Created by Bram Nouwen on 23/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import WatchKit

class OverviewSportRowController: NSObject {

    @IBOutlet var iconImage: WKInterfaceImage!
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var amountLabel: WKInterfaceLabel!
    
    var part: Activity? {
        didSet {
            guard let part = part else { return }
            iconImage.setImageNamed(part.iconName)
            titleLabel.setText(part.title)
            amountLabel.setText(part.goal?.returnOverviewAmountString())
            
            titleLabel.setTextColor(UIColor.white)
        }
    }
}
