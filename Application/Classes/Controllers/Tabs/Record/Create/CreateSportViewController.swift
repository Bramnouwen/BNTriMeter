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
 - https://stackoverflow.com/questions/14520185/how-to-remove-empty-cells-in-uitableview
 */

import UIKit
import IBAnimatable
import SugarRecord

class CreateSportViewController: GradientViewController {
    
    let dataManager = DataManager.shared
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var rowToSelect: IndexPath?
    
    var newPart: Activity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: ActivityTableViewCell.self)
        tableView.tableFooterView = UIView()
        
        let coloredAttributes = [NSAttributedStringKey.font: UIFont(name: "Cabin-Bold", size: 18)!,
                                 NSAttributedStringKey.foregroundColor: UIColor(named: "Bermuda")!]
        
        let descriptionText = NSMutableAttributedString(string: L10n.Create.Sport.Description.one)
        descriptionText.append(NSMutableAttributedString(string: L10n.Create.Sport.Description.two, attributes: coloredAttributes))
        descriptionText.append(NSMutableAttributedString(string: L10n.Create.Sport.Description.three))
        descriptionText.append(NSMutableAttributedString(string: L10n.Create.Sport.Description.four, attributes: coloredAttributes))
        descriptionText.append(NSMutableAttributedString(string: L10n.Create.Sport.Description.five))
        
        descriptionLabel.attributedText = descriptionText
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newPart = dataManager.newPart
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let tableViewId = newPart.tableViewId {
            rowToSelect = IndexPath(row: tableViewId, section: 0)
            tableView.selectRow(at: rowToSelect, animated: true, scrollPosition: .none)
            let cell = tableView.cellForRow(at: rowToSelect!) as? ActivityTableViewCell
            cell?.accessoryType = .checkmark
        }
    }
    
}

extension CreateSportViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.TMCreateActivities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ActivityTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let i = indexPath.row
        
        let tmActivity = dataManager.TMCreateActivities[i]
        
        if let title = tmActivity.title, let iconName = tmActivity.iconName {
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
        print("Selected row: \(indexPath.row), section: \(indexPath.section)")
        let i = indexPath.row
        
        updateNewPart(id: i)
        cell.accessoryType = .checkmark
    }
    
    func updateNewPart(id: Int) {
        let tmActivity = dataManager.TMCreateActivities[id]
        
        if let title = tmActivity.title, let iconName = tmActivity.iconName {
            newPart.title = title
            newPart.iconName = iconName
            newPart.tableViewId = id
            if dataManager.existingPart == false {
                // If we have a new part we have to set the partId, if not we have to keep the old one
                newPart.partId = dataManager.createdActivity.parts?.count
            }
            if newPart.dataLayout == nil {
                newPart.dataLayout = dataManager.TMDefaultData?.convert()
            }
            if newPart.settingsLayout == nil {
                newPart.settingsLayout = dataManager.TMDefaultSettings?.convert()
            }
        }
        
        dataManager.newPart = newPart
    }
}
