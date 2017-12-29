//
//  StartViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 24/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

//Do things like checking if user is already logged in or not
//Maybe preload some data

import UIKit
import Firebase

class StartViewController: UIViewController {
    
    let dataManager = DataManager.shared
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            print("Logged in, continuing to main screen.")
            performSegue(withIdentifier: Segues.startToMainSegueKey, sender: nil)
        } else {
            print("We need to login before continuing.")
            performSegue(withIdentifier: Segues.startToLoginSegueKey, sender: nil)
        }
    }
    
    @IBAction func unwindToStart(_ segue: UIStoryboardSegue) { }

}
