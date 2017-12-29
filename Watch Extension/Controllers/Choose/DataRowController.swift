//
//  DataRowController.swift
//  Watch Extension
//
//  Created by Bram Nouwen on 23/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import WatchKit

class DataRowController: NSObject {
    
    @IBOutlet var iconImage: WKInterfaceImage!
    @IBOutlet var titleLabel: WKInterfaceLabel!
    
    var dataField: DataField? {
        didSet {
            guard let dataField = dataField else { return }
            iconImage.setImageNamed(dataField.iconString)
            titleLabel.setText(dataField.title)
        }
    }
}
