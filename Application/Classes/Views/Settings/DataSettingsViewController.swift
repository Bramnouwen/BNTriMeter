//
//  CustomSubViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 30/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import InAppSettingsKit

class DataSettingsSubViewController: UIViewController {

    init() {
        super.init(nibName: "DataSettingsSubViewController", bundle: Bundle.main)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.applyGradient()
        print("DataSettingsSubViewController did load")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
