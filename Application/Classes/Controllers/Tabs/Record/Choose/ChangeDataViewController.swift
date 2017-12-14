//
//  ChangeDataViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 12/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit

class ChangeDataViewController: GradientViewController, UITableViewDelegate, UITableViewDataSource {

    let dataManager = DataManager.shared
    
    @IBOutlet weak var tableView: UITableView!
    
    var spotAndId: (spot: Int, id: Int)?
    var rowToSelect: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor(named: "Bermuda")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorInset = .zero
        tableView.register(cellType: ChangeDataTableViewCell.self)
        
        let nibChangeData = UINib(nibName: "ChangeDataSectionHeader", bundle: nil)
        tableView.register(nibChangeData, forHeaderFooterViewReuseIdentifier: "ChangeDataSectionHeader")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        guard let index = spotAndId?.id, index != 999 else { return }
//        let i = defineRowByIndexId(index)
//        let s = defineSectionByIndexId(index)
//        rowToSelect = IndexPath(row: i, section: s)
//        tableView.selectRow(at: rowToSelect!, animated: true, scrollPosition: .none)
        //tableView(tableView, didSelectRowAt: rowToSelect!)
        
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataManager.dataListSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 4
        case 1: return 3
        case 2: return 4
        case 3: return 3
        case 4: return 4
        case 5: return 3
        case 6: return 2
        case 7: return 2
        case 8: return 2
        case 9: return 1
        default:
            print("We shouldn't be here (numberOfRowsInSection for ChangeDataTableViewController")
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChangeDataTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let i = indexPath.row
        var item: DataField?
        
        
        
        switch indexPath.section {
        case 0: item = dataManager.dataListSections["Duration"]![i]
        case 1: item = dataManager.dataListSections["Pace"]![i]
        case 2: item = dataManager.dataListSections["Distance"]![i]
        case 3: item = dataManager.dataListSections["Speed"]![i]
        case 4: item = dataManager.dataListSections["Calories"]![i]
        case 5: item = dataManager.dataListSections["Heart rate"]![i]
        case 6: item = dataManager.dataListSections["Steps"]![i]
        case 7: item = dataManager.dataListSections["Elevation"]![i]
        case 8: item = dataManager.dataListSections["Descent"]![i]
        case 9: item = dataManager.dataListSections["Clock"]![i]
        default: print("We shouldn't be here (cellForRowAt for ChangeDataTableViewController")
        }
        
        cell.title.text = item!.title
        cell.explanation.text = item!.descriptionString
        if item!.title.lowercased().contains(L10n.Data.current) {
            cell.colorIndicator.backgroundColor = UIColor(named: "Amaranth")
        } else {
            cell.colorIndicator.backgroundColor = UIColor(named: "Bermuda")
        }
        
        cell.item = item!
        
        if item?.id == spotAndId?.id {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ChangeDataSectionHeader") as! ChangeDataSectionHeader
        
        var title: String?
        var icon: UIImage?
        switch section {
        case 0:
            title = L10n.Data.Duration.total
            icon = #imageLiteral(resourceName: "duration")
        case 1:
            title = L10n.Data.Pace.current
            icon = #imageLiteral(resourceName: "pace")
        case 2:
            title = L10n.Data.Distance.total
            icon = #imageLiteral(resourceName: "distance")
        case 3:
            title = L10n.Data.Speed.current
            icon = #imageLiteral(resourceName: "speed")
        case 4:
            title = L10n.Data.Calories.total
            icon = #imageLiteral(resourceName: "calories")
        case 5:
            title = L10n.Data.Heartrate.current
            icon = #imageLiteral(resourceName: "heart")
        case 6:
            title = L10n.Data.Steps.total
            icon = #imageLiteral(resourceName: "steps")
        case 7:
            title = L10n.Data.Elevation.total
            icon = #imageLiteral(resourceName: "elevation")
        case 8:
            title = L10n.Data.Descent.total
            icon = #imageLiteral(resourceName: "descent")
        case 9:
            title = L10n.Data.clock
            icon = #imageLiteral(resourceName: "duration") 
            
        default: print("We shouldn't be here (viewForHeaderInSection for ChangeDataTableViewController")
        }
        
        header.title.text = title
        header.icon.image = icon
        
        return header
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 53
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChangeDataTableViewCell else { return }
        cell.accessoryType = .none
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChangeDataTableViewCell else { return }
        cell.accessoryType = .checkmark
        if let cellItem = cell.item, let spot = spotAndId?.spot {
            spotAndId?.id = cellItem.id
            
            if (dataManager.currentActivity.dataLayout?.dataFields.indices.contains(spot))! {
                cellItem.spot = spot
                dataManager.currentActivity.dataLayout?.dataFields[spot] = cellItem
            } else {
                cellItem.spot = (dataManager.currentActivity.dataLayout?.dataFields.count)!
                dataManager.currentActivity.dataLayout?.dataFields.append(cellItem)
            }
        }
        
       navigationController?.popViewController(animated: true)
    }
    
    func defineSectionByIndexId(_ i: Int) -> Int {
        switch i {
        case 0, 1, 2, 3: return 0
        case 4, 5, 6: return 1
        case 7, 8, 9, 10: return 2
        case 11, 12, 13: return 3
        case 14, 15, 16, 17: return 4
        case 18, 19, 20: return 5
        case 21, 22: return 6
        case 23, 24: return 7
        case 25, 26: return 8
        case 27: return 9
        default:
            print("Something went wrong defining section")
            return 0
        }
    }
    
    func defineRowByIndexId(_ i: Int) -> Int {
        switch i {
        case 0, 4, 7, 11, 14, 18, 21, 23, 25, 27: return 0
        case 1, 5, 8, 12, 15, 19, 22, 24, 26: return 1
        case 2, 6, 9, 13, 16, 20: return 2
        case 3, 10, 17: return 3
        default:
            print("Something went wrong defining row")
            return 0
        }
    }
    /*
     Duration: 0 1 2 3
     Pace: 4 5 6
     Distance: 7 8 9 10
     Speed: 11 12 13
     Calories: 14 15 16 17
     Heart rate: 18 19 20
     Steps: 21 22
     Elevation: 23 24
     Descent: 25 26
     Clock: 27
     */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
