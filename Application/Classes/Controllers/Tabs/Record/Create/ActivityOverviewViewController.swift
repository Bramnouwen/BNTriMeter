//
//  ActivityOverviewViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 15/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//
/* Referenced
 - https://stackoverflow.com/questions/969313/uitableview-disable-swipe-to-delete-but-still-have-delete-in-edit-mode
 */

import UIKit
import IBAnimatable
import SugarRecord
import SCLAlertView

class ActivityOverviewViewController: GradientViewController, UIActionSheetDelegate {
    
    let dataManager = DataManager.shared
    let defaults = UserDefaults.standard
    let formatters = Formatters.shared
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: AnimatableTextField!
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var summaryTableView: UITableView!
    var setEditingMode = true
    
    @IBOutlet weak var addPartButton: AnimatableButton!
    @IBOutlet weak var selectButton: AnimatableButton!
    
    var activity: Activity!
    var parts: [Activity] = []
    var isExistingWorkout = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = L10n.Create.title
        titleTextField.placeholder = L10n.Create.Title.title
        titleTextField.placeholderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        summaryLabel.text = L10n.Create.summary
        addPartButton.setTitle(L10n.Create.add, for: .normal)
        selectButton.setTitle(L10n.Create.select, for: .normal)
        
        summaryTableView.delegate = self
        summaryTableView.dataSource = self
        summaryTableView.tableFooterView = UIView()
        summaryTableView.setEditing(setEditingMode, animated: false)
        changePageLayout()
        summaryTableView.register(cellType: OverviewSportNormalTableViewCell.self)
        summaryTableView.register(cellType: OverviewTransitionNormalTableViewCell.self)
        summaryTableView.register(cellType: OverviewTransitionEditTableViewCell.self)
        
        parts = activity.parts!
        
        if activity.title != "" {
            titleTextField.text = activity.title
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataManager.createdActivity = activity
        isExistingWorkout = dataManager.activityExists(activity)
        print("Workout exists: \(isExistingWorkout)")
    }
    
    @objc func cancelDeleteBarButtonClicked() {
        // If editing -> delete workout
        if summaryTableView.isEditing {
            showDeleteActionSheet()
        } else {
            // If not editing -> back to main screen without selecting
            if dataManager.unarchive(key: "currentActivity").tableViewId == activity.tableViewId {
                dataManager.archive(activity: activity, key: "currentActivity")
            }
            performSegue(withIdentifier: Segues.toMain, sender: nil)
        }
    }
    
    @objc func saveEditBarButtonClicked() {
        if summaryTableView.isEditing {
            // If saving completed
            if saveWorkout() {
                // Stop editing
                isExistingWorkout = true
                summaryTableView.setEditing(false, animated: true)
                changePageLayout()
            }
        } else {
            // Start editing
            summaryTableView.setEditing(true, animated: true)
            changePageLayout()
        }
    }
    
    
    // Replace above functions by this one
    func changePageLayout() {
        if summaryTableView.isEditing {
            // Editing
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: L10n.Create.delete, style: .plain, target: self, action: #selector(cancelDeleteBarButtonClicked))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.Create.save, style: .plain, target: self, action: #selector(saveEditBarButtonClicked))
            addPartButton.isHidden = false
            addPartButton.isEnabled = true
            selectButton.isHidden = true
            selectButton.isEnabled = false
            summaryTableView.separatorStyle = .singleLine
            titleTextField.borderWidth = 1
            titleTextField.isEnabled = true
        } else {
            // Not
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: L10n.Create.cancel, style: .plain, target: self, action: #selector(cancelDeleteBarButtonClicked))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.Create.edit, style: .plain, target: self, action: #selector(saveEditBarButtonClicked))
            addPartButton.isHidden = true
            addPartButton.isEnabled = false
            selectButton.isHidden = false
            selectButton.isEnabled = true
            summaryTableView.separatorStyle = .none
            titleTextField.borderWidth = 0
            titleTextField.isEnabled = false
        }
    }
    
    
    @IBAction func addPartButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.toCreate, sender: nil)
    }
    
    @IBAction func selectButtonClicked(_ sender: Any) {
        dataManager.archive(activity: activity, key: "currentActivity")
        performSegue(withIdentifier: "unwindSegueToRecordVC", sender: nil)
    }
    
    
    func saveWorkout() -> Bool {
        // If workout doesn't exist, save
        guard activity.title != "" else {
            print("We need a title for the workout")
            showTitleMissingAlert()
            return false
        }
        
        if isExistingWorkout {
            print("Updating workout")
            dataManager.update(activity)
        } else {
            print("Saving workout")
            activity.tableViewId = dataManager.TMActivities.count
            dataManager.save(activity)
        }
        
        dataManager.fetchCoreData()
        return true
    }
    
    @IBAction func titleTextFieldEditingChanged(_ sender: Any) {
        activity.title = titleTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toCreate {
            guard let navVC = segue.destination as? UINavigationController else { return }
            guard let destVC = navVC.childViewControllers.first as? CreateActivityViewController else { return }
            destVC.indexOfPartToUpdate = sender as? Int
        }
    }
    
    // MARK: - Alerts
    
    func showDeleteActionSheet() {
        let alert = UIAlertController(title: nil, message: L10n.Create.Delete.confirmation, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cancel: UIAlertAction = UIAlertAction(title: L10n.Create.cancel, style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        let delete: UIAlertAction = UIAlertAction(title: L10n.Create.delete, style: .destructive, handler: { (action) -> Void in
            if let db = self.dataManager.db,
                let id = self.activity.tableViewId,
                (try! db.fetch(FetchRequest<TMActivity>().filtered(with: "tableViewId", equalTo: "\(id)")).first) != nil {
                self.dataManager.delete(self.activity)
                self.dataManager.fetchCoreData()
                // Set current activity to running after deleting = default determined by myself
                let running = self.dataManager.unarchive(key: "1")
                self.dataManager.archive(activity: running, key: "currentActivity")
            }
            self.dataManager.createdActivity = Activity()
            self.performSegue(withIdentifier: Segues.toMain, sender: nil)
        })
        alert.addAction(delete)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showTitleMissingAlert() {
        let incompleteAppearance = SCLAlertView.SCLAppearance(kTitleFont: UIFont(name: "Cabin-Bold", size: 20)!,
                                                              kTextFont: UIFont(name: "Cabin-Regular", size: 16)!,
                                                              kButtonFont: UIFont(name: "Cabin-Bold", size: 16)!,
                                                              showCloseButton: false)
        let incomplete = SCLAlertView(appearance: incompleteAppearance)
        let titleTextField = incomplete.addTextField(L10n.Alert.Title.Incomplete.title)
        incomplete.addButton(L10n.Alert.Title.Incomplete.done, action: {
            self.activity.title = (titleTextField.text?.trimmingCharacters(in: .whitespaces))!
            self.titleTextField.text = self.activity.title
            if self.saveWorkout() {
                // Stop editing
                self.isExistingWorkout = true
                self.summaryTableView.setEditing(false, animated: true)
                self.changePageLayout()
            }
        })
        incomplete.showError(L10n.Alert.Title.Incomplete.title, subTitle: L10n.Alert.Title.Incomplete.description)
    }
    
    func showTitleExistsAlert() {
        
    }
}

extension ActivityOverviewViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let i = indexPath.row
        
        // part exists
        let part = parts[i]
        if part.title == L10n.Activity.Triathlon.transition {
            let cell: OverviewTransitionNormalTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            
            cell.title.text = part.title
            cell.part = part
            
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell: OverviewSportNormalTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            
            cell.icon.image = UIImage(named: part.iconName!)
            cell.title.text = part.title
            cell.amount.text = part.goal?.returnOverviewAmountString()
            cell.part = part
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataManager.existingPart = true
        if let cell = tableView.cellForRow(at: indexPath) as? OverviewSportNormalTableViewCell {
            dataManager.newPart = cell.part!
            performSegue(withIdentifier: Segues.toCreate, sender: ((cell.part?.partId)!)) // FIXME: Update partId's to start from 0?
        } else if let cell = tableView.cellForRow(at: indexPath) as? OverviewTransitionNormalTableViewCell {
            dataManager.newPart = cell.part!
            performSegue(withIdentifier: Segues.toCreate, sender: ((cell.part?.partId)!))
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let i = indexPath.row
        if editingStyle == .delete {
            if let parts = activity.parts, parts.indices.contains(i) {
                activity.parts?.remove(at: i) // Delete part
                recalculatePartIds()
                //TODO: Fix this
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.summaryTableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    
    func recalculatePartIds() {
        guard let parts = activity.parts else { return }
        var newParts: [Activity] = []
        for (index, part) in parts.enumerated() {
            part.partId = index
            newParts.append(part)
        }
        activity.parts = newParts
        self.parts = newParts
    }
    
}
