//
//  ChooseGoalViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 28/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import IBAnimatable

class CreateGoalViewController: GradientViewController {

    let dataManager = DataManager.shared
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var segmentedSelected = 1
    
    var newPart: Activity!
    
    @IBOutlet weak var obstructionView: UIView!
    @IBOutlet weak var obstructionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: GoalTableViewCell.self)
        
        segmentedControl.setTitle(L10n.Goal.Segmented.slow, forSegmentAt: 0)
        segmentedControl.setTitle(L10n.Goal.Segmented.steady, forSegmentAt: 1)
        segmentedControl.setTitle(L10n.Goal.Segmented.fast, forSegmentAt: 2)
        
        obstructionView.applyGradient()
        obstructionLabel.text = L10n.Create.Obstruction.transition
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newPart = dataManager.newPart
        
        if newPart.title == L10n.Activity.Triathlon.transition {
            obstructionView.isHidden = false
        } else {
            obstructionView.isHidden = true
        }
        
        let coloredAttributes = [NSAttributedStringKey.font: UIFont(name: "Cabin-Bold", size: 18)!,
                                 NSAttributedStringKey.foregroundColor: UIColor(named: "Bermuda")!]
        
        let descriptionText = NSMutableAttributedString(string: L10n.Choose.Goal.Description.one)
        if newPart.title != "" {
            descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Goal.Description.two))
            descriptionText.append(NSMutableAttributedString(string: newPart.title.lowercased(), attributes: coloredAttributes))
        }
        descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Goal.Description.three))
        descriptionLabel.attributedText = descriptionText
        
        if let goalId = newPart.goal?.id {
            let rowToSelect = IndexPath(row: goalId, section: 0)
            tableView.selectRow(at: rowToSelect, animated: true, scrollPosition: .none)
            if let cell = tableView.cellForRow(at: rowToSelect) as? GoalTableViewCell {
                cell.accessoryType = .checkmark
                cell.goalDescription.font = UIFont(name: "Cabin-Bold", size: cell.goalDescription.font.pointSize)
                cell.goalDescription.textColor = UIColor(named: "Bermuda")
                cell.goalDescription.text = newPart.goal?.previousAmountAsString()
            }
        }
    }
    
    @IBAction func segmentedValueChanged(_ sender: Any) {
        let val = segmentedControl.selectedSegmentIndex
        dataManager.newPart.goalSpeed = val
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.adjustGoal {
            guard let destVC = segue.destination as? CreateAdjustGoalViewController else { return }
            destVC.goalId = sender as? Int
            destVC.newPart = newPart
        }
    }
}

extension CreateGoalViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.TMGoals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GoalTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let i = indexPath.row
        
        let goal = dataManager.TMGoals[i].convert()
        
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
            cell.goalDescription.textColor = UIColor(named: "Bermuda")
            
            newPart.goal = dataManager.getGoalById(i)
            newPart.goalSpeed = segmentedSelected
            
            dataManager.newPart = newPart
        }
    }
}
