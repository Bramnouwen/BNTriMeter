//
//  ActivityTableViewCell.swift
//  TriMeter
//
//  Created by Bram Nouwen on 29/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import Reusable

class ActivityTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var activityIcon: UIImageView!
    @IBOutlet weak var activityTitle: UILabel!
    
}
