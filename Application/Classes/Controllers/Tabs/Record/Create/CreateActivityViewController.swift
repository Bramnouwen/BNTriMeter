//
//  ChooseActivityViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 28/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import SCLAlertView

class CreateActivityViewController: UIViewController {

    let dataManager = DataManager.shared
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    
    var controllerToLoad = 0
    
    var indexOfPartToUpdate: Int?
    
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
        let newPart = dataManager.newPart
        if newPart.title == "" || newPart.goal == nil && newPart.title != L10n.Activity.Triathlon.transition {
            showIncompleteAlert()
            return
        }
        
        if dataManager.existingPart == false {
            // If newPart doesn't exist, add
            dataManager.createdActivity.parts?.append(newPart)
        } else {
            // Part already exists, update accordingly
            guard let i = indexOfPartToUpdate else { return }
            dataManager.createdActivity.parts?[i] = newPart
        }
        resetNewPart()
        // Go to overview
        performSegue(withIdentifier: Segues.toOverview, sender: dataManager.createdActivity)
    }
    
    @objc func cancelBarButtonItemClicked() {
        print("Cancelling adding part")
        resetNewPart()
        dismiss(animated: true, completion: nil)
    }
    
    func resetNewPart() {
        dataManager.existingPart = false
        dataManager.newPart = Activity(isPartOfWorkout: true)
    }
    
    func showIncompleteAlert() {
        let incompleteAppearance = SCLAlertView.SCLAppearance(kTitleFont: UIFont(name: "Cabin-Bold", size: 20)!,
                                                              kTextFont: UIFont(name: "Cabin-Regular", size: 16)!,
                                                              kButtonFont: UIFont(name: "Cabin-Bold", size: 16)!,
                                                              showCloseButton: false)
        let incomplete = SCLAlertView(appearance: incompleteAppearance)
        incomplete.addButton(L10n.Alert.Part.Incomplete.done, action: {
            incomplete.dismiss(animated: true, completion: nil)
        })
        incomplete.showError(L10n.Alert.Part.Incomplete.title, subTitle: L10n.Alert.Part.Incomplete.description)
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
