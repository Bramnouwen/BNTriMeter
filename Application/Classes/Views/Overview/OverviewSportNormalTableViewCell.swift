//
//  OverviewSportNormalTableViewCell.swift
//  TriMeter
//
//  Created by Bram Nouwen on 15/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import Reusable

class OverviewSportNormalTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
