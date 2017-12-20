//
//  SettingsTableViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 30/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import InAppSettingsKit
import FBSDKLoginKit
import Firebase
import OneSignal

class SettingsTableViewController: IASKAppSettingsViewController, IASKSettingsDelegate, UIActionSheetDelegate {
    
    let locationManager = LocationManager.shared
    
    func settingsViewControllerDidEnd(_ sender: IASKAppSettingsViewController!) {
        
    }
    
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(settingDidChange(_:)), name: NSNotification.Name(rawValue: kIASKAppSettingChanged), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = L10n.Tabs.settings
        
        delegate = self
        
        let showMapEnabled = UserDefaults.standard.bool(forKey: "showMap")
        if showMapEnabled {
            setHiddenKeys(nil, animated: false)
        } else {
            var keys = Set<NSObject>()
            keys.insert("showMapTo" as NSObject)
            setHiddenKeys(keys, animated: false)
        }
        
        navigationController?.navigationBar.tintColor = Colors.bermuda
//        UISwitch.appearance().tintColor = Colors.bermuda
        UISwitch.appearance().onTintColor = Colors.bermuda
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Settings background color
        tableView.backgroundColor = UIColor(red:0.09, green:0.09, blue:0.09, alpha:1.00)
    }
    
    @objc func settingDidChange(_ notification: Notification!) {
        if (notification.userInfo! as NSDictionary).allKeys.first as! String == "showMap" {
            let showMapEnabled = UserDefaults.standard.bool(forKey: "showMap")
            if showMapEnabled {
                setHiddenKeys(nil, animated: true)
            } else {
                var keys = Set<NSObject>();
                keys.insert("showMapTo" as NSObject)
                setHiddenKeys(keys, animated: true)
            }
        }
    }
    
    func settingsViewController(_ sender: IASKAppSettingsViewController!, buttonTappedFor specifier: IASKSpecifier!){
        if specifier.key() == "LogoutButtonAction" {
            let alert = UIAlertController(title: nil, message: L10n.Logout.confirmation, preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let cancel: UIAlertAction = UIAlertAction(title: L10n.Logout.cancel, style: .cancel, handler: nil)
            alert.addAction(cancel)
            
            let logout: UIAlertAction = UIAlertAction(title: L10n.Logout.logout, style: .destructive, handler: { (action) -> Void in
                do {
                    try Auth.auth().signOut()
                    self.locationManager.stopUpdatingLocation()
                    FBSDKAccessToken.setCurrent(nil)
                    OneSignal.deleteTag("user_id")
                    self.performSegue(withIdentifier: Segues.unwindToWelcome, sender: nil)
                } catch let signOutError as NSError {
                    print ("Error signing out: \(signOutError.localizedDescription)")
                }
            })
            alert.addAction(logout)
            
            sender.present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // Settings cell color
        cell.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.00)
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        //cell.selectionStyle = .none
        cell.focusStyle = .custom
        
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView

        header?.textLabel?.textColor = .white
    }
    
}
