//
//  ActivityOverviewViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 15/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import IBAnimatable
import SugarRecord

class ActivityOverviewViewController: GradientViewController {
    
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

    @objc func cancelDeleteBarButtonClicked() {
            // If editing -> delete workout
        if summaryTableView.isEditing {
            if let db = dataManager.db,
                let id = activity.tableViewId,
                (try! db.fetch(FetchRequest<TMActivity>().filtered(with: "tableViewId", equalTo: "\(id)")).first) != nil {
                dataManager.delete(activity)
                dataManager.fetchCoreData()
                // Set current activity to running after deleting = default determined by myself
                let runningData = defaults.object(forKey: "1") as! Data
                let running = NSKeyedUnarchiver.unarchiveObject(with: runningData) as! Activity
                dataManager.archive(activity: running, key: "currentActivity")
            }
            dataManager.createdActivity = Activity()
            performSegue(withIdentifier: Segues.toMain, sender: nil)
        } else {
            // If not editing -> back to main screen without selecting
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
        guard let title = titleTextField.text, title != "" else {
            print("We need a title for the workout")
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
        activity.title = titleTextField.text ?? ""
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
            
            return cell
        } else {
            let cell: OverviewSportNormalTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            
            cell.icon.image = UIImage(named: part.iconName!)
            cell.title.text = part.title
            cell.amount.text = part.goal?.returnOverviewAmountString()
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? OverviewSportNormalTableViewCell else { return }
        print("Selected \(cell.title.text!)")
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
