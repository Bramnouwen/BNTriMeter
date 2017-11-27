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

class RecordViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = LocationManager.shared
    let regionRadius: CLLocationDistance = 500
    
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activityButton: UIButton!
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalButton: UIButton!
    
    @IBOutlet weak var dataLabel: UILabel!
    
    @IBOutlet weak var data1ImageView: UIImageView!
    @IBOutlet weak var data1Label: UILabel!
    @IBOutlet weak var data1DescriptionLabel: UILabel!
    
    @IBOutlet weak var data2ImageView: UIImageView!
    @IBOutlet weak var data2Label: UILabel!
    @IBOutlet weak var data2DescriptionLabel: UILabel!
    
    @IBOutlet weak var data3ImageView: UIImageView!
    @IBOutlet weak var data3Label: UILabel!
    @IBOutlet weak var data3DescriptionLabel: UILabel!
    
    @IBOutlet weak var data4ImageView: UIImageView!
    @IBOutlet weak var data4Label: UILabel!
    @IBOutlet weak var data4DescriptionLabel: UILabel!
    
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
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.applyGradient()
        activityButton.titleLabel?.adjustsFontSizeToFitWidth = true
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
        
    }
    @IBAction func goalButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func dataTapGestureTapped(_ sender: UITapGestureRecognizer) {
        print("Go to data screen")
    }
    
    // MARK: - Settings actions
    
    @IBAction func liveLocationButtonClicked(_ sender: Any) {
        liveLocationOn = !liveLocationOn
        switch liveLocationOn {
        case true:
            liveLocationButton.setImage(#imageLiteral(resourceName: "Live-location-on"), for: .normal)
            liveLocationButton.alpha = 1
        case false:
            liveLocationButton.setImage(#imageLiteral(resourceName: "Live-location-off"), for: .normal)
            liveLocationButton.alpha = 0.5
        }
    }
    
    @IBAction func countdownButtonClicked(_ sender: Any) {
        countdownOn = !countdownOn
        switch countdownOn {
        case true:
            countdownButton.setImage(#imageLiteral(resourceName: "countdown-on"), for: .normal)
            countdownButton.alpha = 1
        case false:
            countdownButton.setImage(#imageLiteral(resourceName: "countdown-off"), for: .normal)
            countdownButton.alpha = 0.5
        }
    }
    
    @IBAction func autoPauseButtonClicked(_ sender: Any) {
        autoPauseOn = !autoPauseOn
        switch autoPauseOn {
        case true:
            autoPauseButton.setImage(#imageLiteral(resourceName: "autopause-on"), for: .normal)
            autoPauseButton.alpha = 1
        case false:
            autoPauseButton.setImage(#imageLiteral(resourceName: "autopause-off"), for: .normal)
            autoPauseButton.alpha = 0.5
        }
    }
    
    @IBAction func audioButtonClicked(_ sender: Any) {
        audioOn = !audioOn
        switch audioOn {
        case true:
            audioButton.setImage(#imageLiteral(resourceName: "audio-on"), for: .normal)
            audioButton.alpha = 1
        case false:
            audioButton.setImage(#imageLiteral(resourceName: "audio-off"), for: .normal)
            audioButton.alpha = 0.5
        }
    }
    
    @IBAction func hapticButtonClicked(_ sender: Any) {
        hapticOn = !hapticOn
        switch hapticOn {
        case true:
            hapticButton.setImage(#imageLiteral(resourceName: "haptic-on"), for: .normal)
            hapticButton.alpha = 1
        case false:
            hapticButton.setImage(#imageLiteral(resourceName: "haptic-off"), for: .normal)
            hapticButton.alpha = 0.5
        }
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

extension RecordViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //        print("Location = \(locValue.latitude) \(locValue.longitude)")
    }
}
