//
//  RecordViewController.swift
//  TriMeter
//
//  Created by Bram Nouwen on 27/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//
/* Referenced
 - https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
 - https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started
 */

import UIKit
import MapKit
import CoreLocation
import IBAnimatable

class RecordViewController: UIViewController {
    
    let dataManager = DataManager.shared
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = LocationManager.shared
    let regionRadius: CLLocationDistance = 500
    
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activityButton: UIButton!
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalButton: UIButton!
    
    @IBOutlet weak var settingsBarButton: UIBarButtonItem!
    @IBOutlet weak var startActivityButton: AnimatableButton!
    
    @IBOutlet weak var dataLabel: UILabel!
    
    @IBOutlet weak var dataStackView: UIStackView!
    
    @IBOutlet weak var data1StackView: UIStackView!
    @IBOutlet weak var data1ImageView: UIImageView!
    @IBOutlet weak var data1Label: UILabel!
    
    @IBOutlet weak var data2StackView: UIStackView!
    @IBOutlet weak var data2ImageView: UIImageView!
    @IBOutlet weak var data2Label: UILabel!
    
    @IBOutlet weak var data3StackView: UIStackView!
    @IBOutlet weak var data3ImageView: UIImageView!
    @IBOutlet weak var data3Label: UILabel!
    
    @IBOutlet weak var data4StackView: UIStackView!
    @IBOutlet weak var data4ImageView: UIImageView!
    @IBOutlet weak var data4Label: UILabel!
    
    @IBOutlet weak var data5StackView: UIStackView!
    @IBOutlet weak var data5ImageView: UIImageView!
    @IBOutlet weak var data5Label: UILabel!
    
    @IBOutlet weak var liveLocationButton: UIButton!
    var liveLocationOn = false
    
    @IBOutlet weak var countdownButton: UIButton!
    var countdownOn = false
    
    @IBOutlet weak var autoPauseButton: UIButton!
    var autoPauseOn = false
    
    @IBOutlet weak var audioButton: UIButton!
    var audioOn = false
    
    @IBOutlet weak var hapticButton: UIButton!
    var hapticOn = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        settingsBarButton.target = self
        settingsBarButton.action = #selector(settingsTapped)
        
        // Set once
        activityLabel.text = L10n.Record.activity
        goalLabel.text = L10n.Record.goal
        dataLabel.text = L10n.Record.data
        startActivityButton.setTitle(L10n.Record.button, for: .normal)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.applyGradient()
        activityButton.titleLabel?.adjustsFontSizeToFitWidth = true
        goalButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setText()
        turnAllSettingsOnOff()
        setData()
    }
    
    @IBAction func unwindToRecordVC(segue: UIStoryboardSegue) {
        
    }
    
    func setText() {
        guard let a = dataManager.currentActivity else { return }
        activityButton.setTitle(a.title, for: .normal)
        activityButton.setImage(UIImage(named: a.iconName!), for: .normal)
        goalButton.setTitle(a.getGoalString(), for: .normal)
        goalButton.setImage(UIImage(named: a.getGoalIconString()), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkLocationAuthorizationStatus()
        
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse, let currentLocation = locationManager.location {
            mapView.showsUserLocation = true
            centerMapOnLocation(currentLocation)
        } else {
            locationManager.requestWhenInUseAuthorization()
            //          locationManager.requestAlwaysAuthorization() //TODO: To run in background?
        }
    }
    
    // MARK: - Activity actions
    
    @IBAction func activityButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "chooseActivity", sender: 0)
    }
    @IBAction func goalButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "chooseActivity", sender: 1)
    }
    
    @IBAction func dataTapGestureTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "chooseActivity", sender: 2)
    }
    
    @objc func settingsTapped() {
        performSegue(withIdentifier: "chooseActivity", sender: 3)
    }
    
    @IBAction func startActivityButtonClicked(_ sender: Any) {
        print("Start activity, set activity in defaults")
        dataManager.setCurrentActivityInDefaults()
    }
    
    
    // MARK: - Settings actions
    
    func turnSettingOnOff(bool: Bool, button: UIButton, imageOn: UIImage, imageOff: UIImage) {
        switch bool {
        case true:
            button.setImage(imageOn, for: .normal)
            button.alpha = 1
        case false:
            button.setImage(imageOff, for: .normal)
            button.alpha = 0.5
        }
    }
    
    @IBAction func liveLocationButtonClicked(_ sender: Any) {
        liveLocationOn = !liveLocationOn
        turnSettingOnOff(bool: liveLocationOn, button: liveLocationButton, imageOn: #imageLiteral(resourceName: "Live-location-on"), imageOff: #imageLiteral(resourceName: "Live-location-off"))
        dataManager.currentActivity.settingsLayout?.liveLocation = liveLocationOn
    }
    
    @IBAction func countdownButtonClicked(_ sender: Any) {
        countdownOn = !countdownOn
        turnSettingOnOff(bool: countdownOn, button: countdownButton, imageOn: #imageLiteral(resourceName: "countdown-on"), imageOff: #imageLiteral(resourceName: "countdown-off"))
        dataManager.currentActivity.settingsLayout?.countdown = countdownOn
    }
    
    @IBAction func autoPauseButtonClicked(_ sender: Any) {
        autoPauseOn = !autoPauseOn
        turnSettingOnOff(bool: autoPauseOn, button: autoPauseButton, imageOn: #imageLiteral(resourceName: "autopause-on"), imageOff: #imageLiteral(resourceName: "autopause-off"))
        dataManager.currentActivity.settingsLayout?.autopause = autoPauseOn
    }
    
    @IBAction func audioButtonClicked(_ sender: Any) {
        audioOn = !audioOn
        turnSettingOnOff(bool: audioOn, button: audioButton, imageOn: #imageLiteral(resourceName: "audio-on"), imageOff: #imageLiteral(resourceName: "audio-off"))
        dataManager.currentActivity.settingsLayout?.audio = audioOn
    }
    
    @IBAction func hapticButtonClicked(_ sender: Any) {
        hapticOn = !hapticOn
        turnSettingOnOff(bool: hapticOn, button: hapticButton, imageOn: #imageLiteral(resourceName: "haptic-on"), imageOff: #imageLiteral(resourceName: "haptic-off"))
        dataManager.currentActivity.settingsLayout?.haptic = hapticOn
    }
    
    func turnAllSettingsOnOff() {
        if let settings = dataManager.currentActivity.settingsLayout {
            liveLocationOn = settings.liveLocation
            countdownOn = settings.countdown
            autoPauseOn = settings.autopause
            audioOn = settings.audio
            hapticOn = settings.haptic
        }
        
        turnSettingOnOff(bool: liveLocationOn, button: liveLocationButton, imageOn: #imageLiteral(resourceName: "Live-location-on"), imageOff: #imageLiteral(resourceName: "Live-location-off"))
        turnSettingOnOff(bool: countdownOn, button: countdownButton, imageOn: #imageLiteral(resourceName: "countdown-on"), imageOff: #imageLiteral(resourceName: "countdown-off"))
        turnSettingOnOff(bool: autoPauseOn, button: autoPauseButton, imageOn: #imageLiteral(resourceName: "autopause-on"), imageOff: #imageLiteral(resourceName: "autopause-off"))
        turnSettingOnOff(bool: audioOn, button: audioButton, imageOn: #imageLiteral(resourceName: "audio-on"), imageOff: #imageLiteral(resourceName: "audio-off"))
        turnSettingOnOff(bool: hapticOn, button: hapticButton, imageOn: #imageLiteral(resourceName: "haptic-on"), imageOff: #imageLiteral(resourceName: "haptic-off"))
    }
    
    func setData() {
        guard let activity = dataManager.currentActivity else { return }
        let orderedData = activity.getOrderedData()
        let indices = orderedData.indices
        
        if indices.count == 2 {
            dataStackView.spacing = 20
        } else if indices.count == 3 {
            dataStackView.spacing = 15
        } else if indices.count == 4 {
            dataStackView.spacing = 10
        } else if indices.count == 5 {
            dataStackView.spacing = 5
        }
        
        // TODO: Fix with for loop
        if indices.contains(0) {
            data1StackView.isHidden = false
            data1Label.text = orderedData[0].amountString
            data1ImageView.image = UIImage(named: orderedData[0].iconString)
        } else {
            data1StackView.isHidden = true
        }
        
        if indices.contains(1) {
            data2StackView.isHidden = false
            data2Label.text = orderedData[1].amountString
            data2ImageView.image = UIImage(named: orderedData[1].iconString)
        } else {
            data2StackView.isHidden = true
        }
        
        if indices.contains(2) {
            data3StackView.isHidden = false
            data3Label.text = orderedData[2].amountString
            data3ImageView.image = UIImage(named: orderedData[2].iconString)
        } else {
            data3StackView.isHidden = true
        }
        
        if indices.contains(3) {
            data4StackView.isHidden = false
            data4Label.text = orderedData[3].amountString
            data4ImageView.image = UIImage(named: orderedData[3].iconString)
        } else {
            data4StackView.isHidden = true
        }
        
        if indices.contains(4) {
            data5StackView.isHidden = false
            data5Label.text = orderedData[4].amountString
            data5ImageView.image = UIImage(named: orderedData[4].iconString)
        } else {
            data5StackView.isHidden = true
        }
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseActivity" {
            guard let navVC = segue.destination as? UINavigationController else { return }
            let destVC = navVC.viewControllers.first as? ChooseActivityViewController
            destVC?.controllerToLoad = sender as! Int
        }
     }
    
    
}

extension RecordViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let _: CLLocationCoordinate2D = manager.location!.coordinate
        //        print("Location = \(locValue.latitude) \(locValue.longitude)")
    }
}
