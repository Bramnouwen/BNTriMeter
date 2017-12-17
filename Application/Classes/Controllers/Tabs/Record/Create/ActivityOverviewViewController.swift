//
//  ActivityOverviewViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 15/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import IBAnimatable

class ActivityOverviewViewController: GradientViewController {
    
    let dataManager = DataManager.shared
    let defaults = UserDefaults.standard
    let formatters = Formatters.shared
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: AnimatableTextField!
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var summaryTableView: UITableView!
    var setEditingMode = true
    
    @IBOutlet weak var addPartButton: AnimatableButton!
    @IBOutlet weak var selectButton: AnimatableButton!
    
    var activity: Activity!
    var parts: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cancelBarButton.target = self
        cancelBarButton.action = #selector(cancelBarButtonClicked)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.Create.save, style: .plain, target: self, action: #selector(saveEditBarButtonClicked))
        
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
        
        parts = activity.parts!
        
        if title != "" {
            titleTextField.text = title
        }
    }

    @objc func cancelBarButtonClicked() {
            // If editing -> stop editing and delete changes
        if summaryTableView.isEditing {
            summaryTableView.setEditing(false, animated: true)
            changePageLayout()
        } else {
            // If not editing -> back to main screen without selecting
            performSegue(withIdentifier: Segues.toMain, sender: nil)
        }
    }

    @objc func saveEditBarButtonClicked() {
        if summaryTableView.isEditing {
            // Stop editing
            summaryTableView.setEditing(false, animated: true)
            changePageLayout()
            
            saveWorkout()
        } else {
            // Start editing
            summaryTableView.setEditing(true, animated: true)
            changePageLayout()
            
            cancelWorkout() // ?
        }
    }
    
    
    // Replace above functions by this one
    func changePageLayout() {
        if summaryTableView.isEditing {
            // Editing
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
        dataManager.currentActivity = activity
        performSegue(withIdentifier: "unwindSegueToRecordVC", sender: nil)
    }
    
    func saveWorkout() {
        // If workout doesn't exist, save
        guard let title = titleTextField.text else {
            // Show error message: title is necessary
            return
        }
        print("Saving workout with title \(title)")
//        dataManager.saveCreatedActivity(as: title)
        // Else update
        
        dataManager.fetchCoreData()
    }
    
    func cancelWorkout() {
        
    }
    
    @IBAction func titleTextFieldEditingDidEnd(_ sender: Any) {
        dataManager.createdActivity.title = titleTextField.text ?? ""
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
        let part = parts[i]
        if part.title == L10n.Activity.Triathlon.transition {
            let cell: OverviewTransitionNormalTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            
            return cell
        } else {
            let cell: OverviewSportNormalTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            
            cell.icon.image = UIImage(named: part.iconName!)
            cell.title.text = part.title
//            let amountText = Formatters.min0max2Formatter.string(from: part.goal?.amount as! NSNumber)
            cell.amount.text = part.goal?.returnOverviewAmountString()
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? OverviewSportNormalTableViewCell else { return }
        print("Selected \(cell.title.text!)")
    }
    
    
}
