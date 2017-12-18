//
//  OverviewTransitionNormalTableViewCell.swift
//  TriMeter
//
//  Created by Bram Nouwen on 15/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import Reusable

class OverviewTransitionNormalTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var title: UILabel!
    
    var part: Activity?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
