//
//  DataTableViewCell.swift
//  TriMeter
//
//  Created by Bram Nouwen on 29/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import Reusable

class DataTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var dataIcon: UIImageView!
    @IBOutlet weak var dataTitle: UILabel!
    @IBOutlet weak var dataDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
