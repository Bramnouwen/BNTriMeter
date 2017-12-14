//
//  GoalTableViewCell.swift
//  TriMeter
//
//  Created by Bram Nouwen on 29/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import Reusable

class GoalTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var goalIcon: UIImageView!
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var goalDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
