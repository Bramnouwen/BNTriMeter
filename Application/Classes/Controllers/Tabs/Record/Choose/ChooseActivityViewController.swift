//
//  ChooseActivityViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 28/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit

class ChooseActivityViewController: UIViewController {

    let dataManager = DataManager.shared
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var loadBarButtonItem: UIBarButtonItem!
    
    var controllerToLoad = 0
    
    var newActivity: Activity!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        doneBarButtonItem.target = self
        doneBarButtonItem.action = #selector(doneBarButtonItemClicked)
        loadBarButtonItem.target = self
        loadBarButtonItem.action = #selector(loadBarButtonItemClicked)
        loadBarButtonItem.title = L10n.Common.load
        
        title = L10n.Common.Activity.choose
        
        newActivity = dataManager.currentActivity
    }
    
    @objc func doneBarButtonItemClicked() {
        self.dismiss(animated: true, completion: nil)
        print("Done choosing activity")
        
    }
    
    @objc func loadBarButtonItemClicked() {
        print("Loading default data and settings for selected activity")
        // TODO: - Load defaults for selected sport
    }
        
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? ChooseActivityPageViewController else { return }
        destVC.chooseActivityDelegate = self
        destVC.controllerToLoad = controllerToLoad
    }
    
}

extension ChooseActivityViewController: ChooseActivityPageViewControllerDelegate {
    
    func chooseActivityPageViewController(_ chooseActivityPageViewController: ChooseActivityPageViewController,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func chooseActivityPageViewController(_ chooseActivityPageViewController: ChooseActivityPageViewController,
                                    didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
}
