//
//  ChooseSettingsViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 28/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit

class ChooseSettingsViewController: GradientViewController {

    let dataManager = DataManager.shared
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadDefaultButton: UIButton!
    @IBOutlet weak var makeDefaultButton: UIButton!
    
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
    
    
    var settings: SettingsLayout?
    var liveLocationOn = false
    var countdownOn = false
    var autoPauseOn = false
    var audioOn = false
    var hapticOn = false
    
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
        tableView.register(cellType: SettingsTableViewCell.self)
        
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
            descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Settings.Description.one))
            descriptionText.append(NSMutableAttributedString(string: goal.previousAmountAsString().lowercased(), attributes: coloredAttributes))
            descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Settings.Description.two))
            descriptionText.append(NSMutableAttributedString(string: L10n.Choose.Settings.Description.three))
        }
        
        descriptionLabel.attributedText = descriptionText
        loadDefaultButton.setTitle("\(L10n.Choose.Default.load)\n\(title.lowercased())", for: .normal)
        loadDefaultButton.titleLabel?.textAlignment = .center
        makeDefaultButton.setTitle("\(L10n.Choose.Default.make)\n\(title.lowercased())", for: .normal)
        makeDefaultButton.titleLabel?.textAlignment = .center
        
        settings = activity.settingsLayout
        turnAllSettingsOnOff()
        tableView.reloadData()
    }
    
    func turnAllSettingsOnOff() {
        if let settings = activity.settingsLayout {
            liveLocationOn = settings.liveLocation
            countdownOn = settings.countdown
            autoPauseOn = settings.autopause
            audioOn = settings.audio
            hapticOn = settings.haptic
        }
    }

    @IBAction func loadDefaultButtonClicked(_ sender: Any) {
        print("Loading defaults for \(activity.title)")
    }
    
    @IBAction func makeDefaultButtonclicked(_ sender: Any) {
        print("Loading defaults for \(activity.title)")
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
        
        switch i {
        case 0:
            turnSettingOnOff(bool: liveLocationOn, cell: cell)
        case 1:
            turnSettingOnOff(bool: countdownOn, cell: cell, isCountdown: true)
        case 2:
            turnSettingOnOff(bool: autoPauseOn, cell: cell)
        case 3:
            turnSettingOnOff(bool: audioOn, cell: cell)
        case 4:
            turnSettingOnOff(bool: hapticOn, cell: cell)
        default:
            print("We shouldn't be here (cellForRowAt ChooseSettingsViewController")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SettingsTableViewCell else { return }
        let i = indexPath.row
        var bool: Bool?
        
        switch i {
        case 0:
            liveLocationOn = !liveLocationOn
            bool = liveLocationOn
            activity.settingsLayout?.liveLocation = liveLocationOn
        case 1:
            countdownOn = !countdownOn
            bool = countdownOn
            activity.settingsLayout?.countdown = countdownOn
            if countdownOn {
                performSegue(withIdentifier: "adjustGoal", sender: 5)
            }
            turnSettingOnOff(bool: bool!, cell: cell, isCountdown: true)
            return
        case 2:
            autoPauseOn = !autoPauseOn
            bool = autoPauseOn
            activity.settingsLayout?.autopause = autoPauseOn
        case 3:
            audioOn = !audioOn
            bool = audioOn
            activity.settingsLayout?.audio = audioOn
        case 4:
            hapticOn = !hapticOn
            bool = hapticOn
            activity.settingsLayout?.haptic = hapticOn
        default:
            print("We shouldn't be here (didSelectRowAt ChooseSettingsViewController")
        }
        
        turnSettingOnOff(bool: bool!, cell: cell)
    }
    
    func turnSettingOnOff(bool: Bool, cell: SettingsTableViewCell, isCountdown: Bool = false) {
        switch bool {
        case true:
            if isCountdown {
                cell.settingsOnOff.text = "\(UserDefaults.standard.integer(forKey: "previousCountdown"))s"
            } else {
                cell.settingsOnOff.text = L10n.Settings.on
            }
            cell.settingsOnOff.textColor = Colors.bermuda
        case false:
            cell.settingsOnOff.text = L10n.Settings.off
            cell.settingsOnOff.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)
        }
        
        dataManager.archive(activity: activity, key: "currentActivity")
    }
}

// Screen support

import Device
extension ChooseSettingsViewController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        switch Device.size() {
        case .screen4Inch: //iPhone 5
            distanceToDefaultButtons.constant = 25
        default:
            _ = "Silence default warning"
        }
    }
}
