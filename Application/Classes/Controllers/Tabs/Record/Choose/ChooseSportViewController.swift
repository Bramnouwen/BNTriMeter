//
//  ChooseSportViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 28/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//
/* Referenced
 - https://stackoverflow.com/questions/30059704/uitableviewcell-checkmark-to-be-toggled-on-and-off-when-tapped-swift
 - https://stackoverflow.com/questions/31247991/how-to-programmatically-select-a-row-in-uitableview-in-swift-1-2-xcode-6-4
 
 */

import UIKit
import IBAnimatable
import SugarRecord

class ChooseSportViewController: GradientViewController {
    
    let dataManager = DataManager.shared
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createWorkoutButton: AnimatableButton!
    @IBOutlet weak var createWorkoutDescriptionLabel: UILabel!
    
    var rowToSelect: IndexPath?
    
    var activity: Activity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: ActivityTableViewCell.self)
        
        let coloredAttributes = [NSAttributedStringKey.font: UIFont(name: "Cabin-Bold", size: 18)!,
                                 NSAttributedStringKey.foregroundColor: Colors.bermuda]
        
        let descriptionText = NSMutableAttributedString(string: L10n.Choose.Sport.Description.one)
        descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Sport.Description.two, attributes: coloredAttributes))
        descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Sport.Description.three))
        descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Sport.Description.four, attributes: coloredAttributes))
        descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Sport.Description.five))
        
        descriptionLabel.attributedText = descriptionText
        createWorkoutButton.setTitle(L10n.Common.Createworkout.button, for: .normal)
        createWorkoutDescriptionLabel.text = L10n.Common.Createworkout.description
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activity = dataManager.unarchive(key: "currentActivity")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Can't work anymore due to rowId not being equal to an activity's tableViewId
        var tableViewId = 0
        for (index, tmActivity) in dataManager.TMActivities.enumerated() {
            if tmActivity.title == activity.title {
                tableViewId = index
            }
            
        }
        rowToSelect = IndexPath(row: tableViewId, section: 0)
        tableView.selectRow(at: rowToSelect, animated: true, scrollPosition: .none)
        let cell = tableView.cellForRow(at: rowToSelect!) as? ActivityTableViewCell
        cell?.accessoryType = .checkmark
    }
    
    @IBAction func createWorkoutButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.createWorkout, sender: nil)
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toOverview {
            guard let navVC = segue.destination as? UINavigationController else { return }
            guard let destVC = navVC.childViewControllers.first as? ActivityOverviewViewController else { return }
            let values = sender as! (activity: Activity, editing: Bool)
            destVC.activity = values.activity
            destVC.setEditingMode = values.editing
        }
     }
    
    
}

extension ChooseSportViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.TMActivities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ActivityTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let i = indexPath.row
        
        let tmActivity = dataManager.TMActivities[i]
        
        cell.TMActivity = tmActivity // FIXME: Necessary?
        
        if let title = tmActivity.title, let iconName = tmActivity.iconName {
            cell.activityTitle.text = title
            cell.activityIcon.image = UIImage(named: iconName)
        }
        
        if indexPath == rowToSelect {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ActivityTableViewCell else { return }
        cell.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ActivityTableViewCell else { return }
        let i = Int(cell.TMActivity.tableViewId)
        
        if selectedIsPreset(id: i) {
            let activity = dataManager.unarchive(key: "\(i)")
            performSegue(withIdentifier: Segues.toOverview, sender: (activity: activity, editing: false))
        } else {
            if activity.isPreset {
//                dataManager.getCurrentActivityBy(id: i)
                activity = dataManager.unarchive(key: "\(i)")
            } else {
                updateActivity(id: i)
            }
            cell.accessoryType = .checkmark
            dataManager.archive(activity: activity, key: "currentActivity")
        }
        
    }
    
    func updateActivity(id: Int) {
        let tmActivity = dataManager.TMActivities[id]
        if let title = tmActivity.title, let iconName = tmActivity.iconName {
            activity.title = title
            activity.iconName = iconName
            activity.tableViewId = id
        }
    }
    
    func selectedIsPreset(id: Int) -> Bool {
        let activity = dataManager.unarchive(key: "\(id)")
        if activity.isPreset {
            return true
        } else {
            return false
        }
    }
    
}
