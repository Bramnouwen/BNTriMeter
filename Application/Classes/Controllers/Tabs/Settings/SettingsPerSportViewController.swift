//
//  SettingsPerSportViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 2/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import IBAnimatable

class SettingsPerSportViewController: GradientViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var defaultsLabel: UILabel!
    @IBOutlet weak var sportTextField: AnimatableTextField!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var settingsTableView: UITableView!
    
    //TODO: Formatters: seconds to 0:00:00, 0:00, 0,00
    var dataTitles = [L10n.Data.Duration.total,
                      L10n.Data.Pace.current,
                      L10n.Data.Distance.total,
                      L10n.Data.Calories.total,
                      L10n.Data.add]
    
    //TODO: formatters, add support for 5th
    var dataDescriptions = [L10n.Data.Duration.amount(0),
                            L10n.Data.Pace.amount(0),
                            L10n.Data.Distance.amount(0),
                            L10n.Data.Calories.amount(0),
                            "-"]
    
    var dataIcons = [#imageLiteral(resourceName: "duration"),
                     #imageLiteral(resourceName: "pace"),
                     #imageLiteral(resourceName: "distance"),
                     #imageLiteral(resourceName: "calories")]
    
    var settingsTitles = [L10n.Settings.Livelocation.title,
                          L10n.Settings.Countdown.title,
                          L10n.Settings.Autopause.title,
                          L10n.Settings.Audio.title,
                          L10n.Settings.Haptic.title]
    
    var settingsDescriptions = [L10n.Settings.Livelocation.description,
                                L10n.Settings.Countdown.description,
                                L10n.Settings.Autopause.description,
                                L10n.Settings.Audio.description,
                                L10n.Settings.Haptic.description]
    
    let pickerView = UIPickerView()
    let pickerOptions = [L10n.Activity.walking,
                         L10n.Activity.running,
                         L10n.Activity.cycling,
                         L10n.Activity.swimming,
                         L10n.Activity.Triathlon.superSprint,
                         L10n.Activity.Triathlon.sprint,
                         L10n.Activity.Triathlon.olympic]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataTableView.dataSource = self
        dataTableView.delegate = self
        dataTableView.register(cellType: DataTableViewCell.self)
        dataTableView.isEditing = true
        
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.register(cellType: SettingsTableViewCell.self)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetTapped))
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(0, inComponent: 0, animated: true)
        sportTextField.inputView = pickerView
    }
    
    private func textFieldDidBeginEditing(_ textField: AnimatableTextField) {
        print("did begin editing")
        switch textField {
        case sportTextField:
            if sportTextField.text == "" {
                sportTextField.text = L10n.Activity.walking
            }
        default: print("default")
        }
    }

    @objc func resetTapped() {
        print("Resetting defaults")
    }
    
    
    // MARK: - Picker functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sportTextField.text = pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
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

extension SettingsPerSportViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dataTableView {
            return dataTitles.count
        } else {
            return settingsTitles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let i = indexPath.row
        if tableView == dataTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath) as DataTableViewCell
            
            cell.dataTitle.text = dataTitles[i]
            cell.dataDescription.text = dataDescriptions[i]

            if dataTitles[i] != L10n.Data.add {
                cell.dataIcon.image = dataIcons[i]
            } else {
                cell.dataIcon.image = nil
                cell.dataTitle.alpha = 0.5
                cell.dataDescription.alpha = 0.5
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as SettingsTableViewCell
            
            cell.settingsTitle.text = settingsTitles[i]
            cell.settingsDescription.text = settingsDescriptions[i]
            cell.settingsOnOff.text = L10n.Settings.off
            return cell
        }
        
    }
    
    //    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    //        guard let cell = tableView.cellForRow(at: indexPath) as? DataTableViewCell else { return }
    //
    //    }
    //
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        guard let cell = tableView.cellForRow(at: indexPath) as? DataTableViewCell else { return }
    //
    //    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let i = indexPath.row
        guard tableView == dataTableView else { return }
        if editingStyle == .delete {
            guard let cell = tableView.cellForRow(at: indexPath) as? DataTableViewCell else { return }
            dataTitles[i] = L10n.Data.add
            dataDescriptions[i] = "-"
            removeDataFrom(cell, at: i)
            //TODO: Fix this
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }

        } else if editingStyle == .insert {
            print("Add clicked at index \(i)")
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let i = indexPath.row
        guard tableView == dataTableView else { return .delete }
        if dataTitles[i] != L10n.Data.add {
            return .delete
        } else {
            return .insert
        }
    }
    
    func removeDataFrom(_ cell: DataTableViewCell, at i: Int) {
        cell.dataTitle.text = dataTitles[i]
        cell.dataDescription.text = dataDescriptions[i]
        cell.dataIcon.image = nil
        cell.dataTitle.alpha = 0.5
        cell.dataDescription.alpha = 0.5
    }
}
