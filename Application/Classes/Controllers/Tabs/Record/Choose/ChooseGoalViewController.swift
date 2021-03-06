//
//  ChooseGoalViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 28/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import IBAnimatable

class ChooseGoalViewController: GradientViewController {

    let dataManager = DataManager.shared
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createWorkoutButton: AnimatableButton!
    @IBOutlet weak var createWorkoutDescriptionLabel: UILabel!
    
    var activity: Activity!
    
    @IBOutlet weak var obstructionView: UIView!
    @IBOutlet weak var obstructionLabel: UILabel!
    @IBOutlet weak var obstructionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: GoalTableViewCell.self)
        
        createWorkoutButton.setTitle(L10n.Common.Createworkout.button, for: .normal)
        createWorkoutDescriptionLabel.text = L10n.Common.Createworkout.description
        
        obstructionView.applyGradient()
        obstructionLabel.text = L10n.Choose.obstruction
        obstructionButton.setTitle(L10n.Choose.Obstruction.toOverview, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activity = dataManager.unarchive(key: "currentActivity")
        
        if activity.isPreset {
            obstructionView.isHidden = false
        } else {
            obstructionView.isHidden = true
        }
        
        let coloredAttributes = [NSAttributedStringKey.font: UIFont(name: "Cabin-Bold", size: 18)!,
                                 NSAttributedStringKey.foregroundColor: Colors.bermuda]
        
        let descriptionText = NSMutableAttributedString(string: L10n.Choose.Goal.Description.one)
        descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Goal.Description.two))
        descriptionText.append(NSMutableAttributedString(string: activity.title.lowercased(), attributes: coloredAttributes))
        descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Goal.Description.three))
        
        descriptionLabel.attributedText = descriptionText
        
        if let goalId = activity.goal?.id {
            let rowToSelect = IndexPath(row: goalId, section: 0)
            tableView.selectRow(at: rowToSelect, animated: true, scrollPosition: .none)
            if let cell = tableView.cellForRow(at: rowToSelect) as? GoalTableViewCell {
                cell.accessoryType = .checkmark
                cell.goalDescription.font = UIFont(name: "Cabin-Bold", size: cell.goalDescription.font.pointSize)
                cell.goalDescription.textColor = Colors.bermuda
                cell.goalDescription.text = activity.goal?.previousAmountAsString()
            }
        }
    }
    
    @IBAction func createWorkoutButtonclicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.createWorkout, sender: nil)
    }
    
    @IBAction func obstructionButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.toOverview, sender: (activity: activity, editing: false))
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.adjustGoal {
            guard let destVC = segue.destination as? AdjustGoalViewController else { return }
            destVC.goalId = sender as? Int
            destVC.activity = activity
        } else if segue.identifier == Segues.toOverview {
            guard let navVC = segue.destination as? UINavigationController else { return }
            guard let destVC = navVC.childViewControllers.first as? ActivityOverviewViewController else { return }
            let values = sender as! (activity: Activity, editing: Bool)
            destVC.activity = values.activity
            destVC.setEditingMode = values.editing
        }
    }
}

extension ChooseGoalViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GoalTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let i = indexPath.row
        
        let goal = dataManager.goals[i]
        
        cell.goalIcon.image = UIImage(named: goal.iconName)
        cell.goalTitle.text = goal.title
        cell.goalDescription.text = goal.previousAmountAsString()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? GoalTableViewCell {
            cell.accessoryType = .none
            cell.goalDescription.font = UIFont(name: "Cabin-Regular", size: cell.goalDescription.font.pointSize)
            cell.goalDescription.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? GoalTableViewCell {
            let i = indexPath.row
            if i != 4 {
                performSegue(withIdentifier: Segues.adjustGoal, sender: indexPath.row)
            }
            
            cell.accessoryType = .checkmark
            cell.goalDescription.font = UIFont(name: "Cabin-Bold", size: cell.goalDescription.font.pointSize)
            cell.goalDescription.textColor = Colors.bermuda
            
            activity.goal = dataManager.getGoalById(i)
            dataManager.archive(activity: activity, key: "currentActivity")
        }
    }
}
