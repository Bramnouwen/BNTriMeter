//
//  ChooseActivityViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 28/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit

class CreateActivityViewController: UIViewController {

    let dataManager = DataManager.shared
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    
    var controllerToLoad = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBarButtonItem.target = self
        addBarButtonItem.action = #selector(addBarButtonItemClicked)
        addBarButtonItem.title = L10n.Common.add
        cancelBarButtonItem.target = self
        cancelBarButtonItem.action = #selector(cancelBarButtonItemClicked)
        
        title = L10n.Common.Activity.create
    }
    
    @objc func addBarButtonItemClicked() {
        // TODO: Check if part is complete, if not show error message
        print("Adding part")
        // Add newPart
        dataManager.createdActivity.parts?.append(dataManager.newPart)
        // Reset newPart
        dataManager.newPart = Activity(isPartOfWorkout: true)
        // Go to overview
        performSegue(withIdentifier: Segues.toOverview, sender: dataManager.createdActivity)
    }
    
    @objc func cancelBarButtonItemClicked() {
        print("Cancelling adding part")
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toOverview {
            guard let navVC = segue.destination as? UINavigationController else { return }
            guard let destVC = navVC.childViewControllers.first as? ActivityOverviewViewController else { return }
            destVC.activity = sender as? Activity
        } else {
            guard let destVC = segue.destination as? CreateActivityPageViewController else { return }
            destVC.createActivityDelegate = self
            destVC.controllerToLoad = controllerToLoad
        }
    }
}

extension CreateActivityViewController: CreateActivityPageViewControllerDelegate {
    
    func createActivityPageViewController(_ createActivityPageViewController: CreateActivityPageViewController,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func createActivityPageViewController(_ createActivityPageViewController: CreateActivityPageViewController,
                                    didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
}
