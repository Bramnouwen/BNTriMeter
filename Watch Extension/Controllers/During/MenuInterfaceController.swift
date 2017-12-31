//
//  MenuInterfaceController.swift
//  Watch Extension
//
//  Created by Bram Nouwen on 28/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import WatchKit
import HealthKit

class MenuInterfaceController: WKInterfaceController {

    let wm = WorkoutManager.shared
    
    @IBOutlet var lockButton: WKInterfaceButton!
    @IBOutlet var lockLabel: WKInterfaceLabel!
    
    @IBOutlet var stopButton: WKInterfaceButton!
    @IBOutlet var stopLabel: WKInterfaceLabel!
    
    @IBOutlet var playPauseButton: WKInterfaceButton!
    @IBOutlet var playPauseIcon: WKInterfaceImage!
    @IBOutlet var playPauseLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("Awake")
        
        setTitle(wm.activity?.title)
    }
    
    override func willActivate() {
        super.willActivate()
        print("Will activate")
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        print("Did deactivate")
    }
    
    @IBAction func lockButtonClicked() {
        if #available(watchOS 4.0, *) {
            guard WKInterfaceDevice.current().waterResistanceRating == .wr50 else { return }
            WKExtension.shared().enableWaterLock()
        } else {
            // Alert water lock is unavailable pre-watchOS4
        }
    }
    
    @IBAction func stopButtonClicked() {
        guard wm.workoutSession != nil else { return }
        print("Stop button clicked")
        wm.timer?.invalidate()
        wm.healthStore.end(wm.workoutSession!)
    }
    
    @IBAction func playPauseButtonClicked() {
        guard wm.workoutSession != nil else { return }
        print("PlayPause button clicked")
        if !wm.workoutIsActive {
            // Resume workout
            wm.cumulativePauseTime += Date().timeIntervalSince(wm.pauseDate)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "startTimer"), object: self)
            wm.healthStore.resumeWorkoutSession(wm.workoutSession!)
            wm.workoutIsActive = true
            playPauseLabel.setText("Pause")
            playPauseIcon.setImageNamed("pause-green")
        } else {
            // Pause workout
            wm.pauseDate = Date()
            wm.timer?.invalidate()
            wm.healthStore.pause(wm.workoutSession!)
            wm.workoutIsActive = false
            playPauseLabel.setText("Resume")
            playPauseIcon.setImageNamed("play-green")
        }
    }
    
}
