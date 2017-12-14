//
//  ChooseSettingsViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 28/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit

class ChooseSettingsViewController: GradientViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadDefaultButton: UIButton!
    @IBOutlet weak var makeDefaultButton: UIButton!
    
    var currentActivity = "Wandelen" //TODO: Get chosen activity
    var chosenGoal = "60 minuten" //TODO: Get chosen goal
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: SettingsTableViewCell.self)
        
        let coloredAttributes = [NSAttributedStringKey.font: UIFont(name: "Cabin-Bold", size: 18)!,
                                 NSAttributedStringKey.foregroundColor: UIColor(named: "Bermuda")!]
        
        let descriptionText = NSMutableAttributedString(string: currentActivity, attributes: coloredAttributes)
        descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Settings.Description.one))
        descriptionText.append(NSMutableAttributedString(string: chosenGoal, attributes: coloredAttributes))
        descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Settings.Description.two))
        descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Settings.Description.three))
        
        descriptionLabel.attributedText = descriptionText
        loadDefaultButton.setTitle("\(L10n.Choose.Default.load)\n\(currentActivity.lowercased())", for: .normal)
        loadDefaultButton.titleLabel?.textAlignment = .center
        makeDefaultButton.setTitle("\(L10n.Choose.Default.make)\n\(currentActivity.lowercased())", for: .normal)
        makeDefaultButton.titleLabel?.textAlignment = .center
        
    }

    @IBAction func loadDefaultButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func makeDefaultButtonclicked(_ sender: Any) {
        
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

extension ChooseSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let i = indexPath.row
        
        cell.settingsTitle.text = settingsTitles[i]
        cell.settingsDescription.text = settingsDescriptions[i]
        cell.settingsOnOff.text = L10n.Settings.off
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) as? SettingsTableViewCell else { return }
//        
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) as? SettingsTableViewCell else { return }
//        
//    }
}
