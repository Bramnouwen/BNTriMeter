//
//  SettingsTableViewCell.swift
//  TriMeter
//
//  Created by Bram Nouwen on 29/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import Reusable

class ChangeDataTableViewCell: UITableViewCell , NibReusable {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var explanation: UILabel!
    @IBOutlet weak var colorIndicator: UIView!
    
    var item: DataField?
}
