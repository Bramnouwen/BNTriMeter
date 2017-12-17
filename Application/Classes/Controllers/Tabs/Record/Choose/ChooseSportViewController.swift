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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: ActivityTableViewCell.self)
        
        let coloredAttributes = [NSAttributedStringKey.font: UIFont(name: "Cabin-Bold", size: 18)!,
                                 NSAttributedStringKey.foregroundColor: UIColor(named: "Bermuda")!]
        
        let descriptionText = NSMutableAttributedString(string: L10n.Choose.Sport.Description.one)
        descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Sport.Description.two, attributes: coloredAttributes))
        descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Sport.Description.three))
        descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Sport.Description.four, attributes: coloredAttributes))
        descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Sport.Description.five))
        
        descriptionLabel.attributedText = descriptionText
        createWorkoutButton.setTitle(L10n.Common.Createworkout.button, for: .normal)
        createWorkoutDescriptionLabel.text = L10n.Common.Createworkout.description
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let activity = dataManager.currentActivity, let tableViewId = activity.tableViewId {
            let rowToSelect = IndexPath(row: tableViewId, section: 0)
            tableView.selectRow(at: rowToSelect, animated: true, scrollPosition: .none)
            let cell = tableView.cellForRow(at: rowToSelect) as? ActivityTableViewCell
            cell?.accessoryType = .checkmark
        }
    }
    
    @IBAction func createWorkoutButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.createWorkout, sender: nil)
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
        
        cell.TMActivity = dataManager.TMActivities[i]
        
        if let title = dataManager.TMActivities[i].title, let iconName = dataManager.TMActivities[i].iconName {
            cell.activityTitle.text = title
            cell.activityIcon.image = UIImage(named: iconName)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ActivityTableViewCell else { return }
        cell.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ActivityTableViewCell else { return }
        cell.accessoryType = .checkmark
        let i = indexPath.row
        
        if selectedIsPreset(id: i) {
            print("Loading preset (TODO: go to overview)")
            self.dismiss(animated: true, completion: nil)
        } else {
            if dataManager.currentActivity.isPreset() {
                dataManager.getCurrentActivityBy(id: i)
            } else {
                updateCurrentActivity(id: i)
            }
        }
        
    }
    
    func updateCurrentActivity(id: Int) {
        if let title = dataManager.TMActivities[id].title, let iconName = dataManager.TMActivities[id].iconName {
            dataManager.currentActivity.title = title
            dataManager.currentActivity.iconName = iconName
            dataManager.currentActivity.tableViewId = id
        }
    }
    
    func selectedIsPreset(id: Int) -> Bool {
        if let selectedActivity = defaults.object(forKey: "\(id)") {
            let activityData = selectedActivity as! Data
            let activity = NSKeyedUnarchiver.unarchiveObject(with: activityData) as! Activity
            if activity.parts?.count != 0 {
                dataManager.currentActivity = activity
                return true
            } else {
                return false
            }
        }
        return false // TODO: Should not be reachable
    }
    
}
