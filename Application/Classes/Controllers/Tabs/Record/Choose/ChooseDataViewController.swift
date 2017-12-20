//
//  ChooseDataViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 28/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//
/* Referenced
 - https://www.hackingwithswift.com/example-code/uikit/how-to-swipe-to-delete-uitableviewcells
 */

import UIKit

class ChooseDataViewController: GradientViewController {

    let dataManager = DataManager.shared
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dataDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadDefaultButton: UIButton!
    @IBOutlet weak var makeDefaultButton: UIButton!
    
    var currentData: [DataField] = [] {
        didSet {
            for (index, data) in currentData.enumerated() {
                data.spot = index
            }
        }
    }
    
    var activity: Activity!
    
    @IBOutlet weak var obstructionView: UIView!
    @IBOutlet weak var obstructionLabel: UILabel!
    @IBOutlet weak var obstructionButton: UIButton!
    
    // Constraints
    @IBOutlet weak var distanceToDefaultButtons: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: DataTableViewCell.self)
        tableView.isEditing = true
        
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
        
        let title = activity.title
        
        let descriptionText = NSMutableAttributedString(string: title, attributes: coloredAttributes)
        if let goal = activity.goal {
            descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Data.Description.one))
            descriptionText.append(NSMutableAttributedString(string: goal.previousAmountAsString().lowercased(), attributes: coloredAttributes))
            descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Data.Description.two))
            descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Data.Description.three))
        }
        
        descriptionLabel.attributedText = descriptionText
        dataDescriptionLabel.text = L10n.Choose.Data.Description.data
        loadDefaultButton.setTitle("\(L10n.Choose.Default.load)\n\(title.lowercased())", for: .normal)
        loadDefaultButton.titleLabel?.textAlignment = .center
        makeDefaultButton.setTitle("\(L10n.Choose.Default.make)\n\(title.lowercased())", for: .normal)
        makeDefaultButton.titleLabel?.textAlignment = .center
        
        currentData = activity.getOrderedData()
        tableView.reloadData()
    }
    
    @IBAction func loadDefaultButtonClicked(_ sender: Any) {
        print("Loading default for \(activity.title)")
    }
    
    @IBAction func makeDefaultButtonClicked(_ sender: Any) {
        print("Setting default for \(activity.title)")
    }
    
    @IBAction func obstructionButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.toOverview, sender: (activity: activity, editing: false))
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.changeData {
            guard let destVC = segue.destination as? ChangeDataViewController else { return }
            destVC.spotAndId = sender as? (spot: Int, id: Int)
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

extension ChooseDataViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DataTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let i = indexPath.row
        
        if currentData.count != 0 {
            if currentData.indices.contains(i) {
                cell.dataTitle.text = currentData[i].title
                cell.dataDescription.text = currentData[i].amountString
                cell.dataIcon.image = UIImage(named: currentData[i].iconString)
                cell.dataTitle.alpha = 1
                cell.dataDescription.alpha = 1
            } else {
                cell.dataIcon.image = nil
                cell.dataTitle.alpha = 0.5
                cell.dataDescription.alpha = 0.5
                cell.dataTitle.text = L10n.Data.add
                cell.dataDescription.text = "-"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (tableView.cellForRow(at: indexPath) as? DataTableViewCell) != nil else { return }
        let i = indexPath.row
        print("Selected row at index \(i)")
        if currentData.indices.contains(i) {
            performSegue(withIdentifier: Segues.changeData, sender: (spot: i, id: currentData[i].id))
        } else {
            performSegue(withIdentifier: Segues.changeData, sender: (spot: i, id: 999))
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let i = indexPath.row
        if editingStyle == .delete {
            if currentData.indices.contains(i) && currentData.count != 1 {
                currentData.remove(at: i)
                activity.dataLayout?.dataFields = currentData
                // FIXME: Fix animation without async reload
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    tableView.reloadData()
                }
            }
        } else if editingStyle == .insert {
            print("Add clicked at index \(i)")
            performSegue(withIdentifier: Segues.changeData, sender: (spot: i, id: 999))
        }
        dataManager.archive(activity: activity, key: "currentActivity")
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let i = indexPath.row
        
        if currentData.indices.contains(i) {
            return .delete
        } else {
            return .insert
        }
    }
}

// Screen support

import Device
extension ChooseDataViewController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        switch Device.size() {
        case .screen4Inch: //iPhone 5
            print("5")
            distanceToDefaultButtons.constant = 25
        case .screen4_7Inch: //iPhone 8
            print("8")
            
        case .screen5_5Inch: //iPhone 8+
            print("8+")
            
        case .screen5_8Inch: //iPhone x
            print("X")
            
        default:
            print("Size not supported")
        }
    }
}

