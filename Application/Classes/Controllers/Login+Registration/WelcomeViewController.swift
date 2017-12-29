//
//  WelcomeViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 24/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import IBAnimatable

class WelcomeViewController: GradientViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var continueButton: AnimatableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        welcomeLabel.text = L10n.Welcome.welcome
        descriptionLabel.text = L10n.Welcome.description
        continueButton.setTitle(L10n.Common.continueText, for: .normal)
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
