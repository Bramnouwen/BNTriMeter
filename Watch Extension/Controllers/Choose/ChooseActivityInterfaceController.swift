//
//  ChooseActivityInterfaceController.swift
//  Watch Extension
//
//  Created by Bram Nouwen on 21/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ChooseActivityInterfaceController: WKInterfaceController, ActivityDelegate {
    
    let wm = WorkoutManager.shared
    
    var session: WCSession!
        
    @IBOutlet var activitiesTable: WKInterfaceTable!
    
    var activities: [Activity] = []
    var savePath = getDocumentsDirectory().appendingPathComponent("activities_file").path

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("Awake")
        
        // To configure and activate the session
        if WCSession.isSupported() {
            session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        setupTableView()
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
    
    func setupTableView() {
        // Read activities
        NSKeyedUnarchiver.setClass(Activity.self, forClassName: "Activity")
        NSKeyedUnarchiver.setClass(DataField.self, forClassName: "DataField")
        NSKeyedUnarchiver.setClass(DataLayout.self, forClassName: "DataLayout")
        NSKeyedUnarchiver.setClass(Goal.self, forClassName: "Goal")
        NSKeyedUnarchiver.setClass(SettingsLayout.self, forClassName: "SettingsLayout")
        
        activities = NSKeyedUnarchiver.unarchiveObject(withFile: savePath) as? [Activity] ?? [Activity]()
        
        activitiesTable.setNumberOfRows(activities.count, withRowType: "ActivityRow")
        
        for index in 0..<activitiesTable.numberOfRows {
            guard let controller = activitiesTable.rowController(at: index) as? ActivityRowController else { return }
            
            controller.activity = activities[index]
            controller.delegate = self
        }
    }
    
    func presentGoalScreen(_ activity: Activity) {
        wm.activity = activity
        presentController(withNames: ["GoalController", "DataController", "SettingsController"], contexts: nil)
    }
    
    func presentOverview(_ activity: Activity) {
        wm.activity = activity
        presentController(withName: "OverviewController", context: nil)
    }
    
}

// WCSession Delegate protocol
extension ChooseActivityInterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Activation did complete with \(activationState)")
    }
    
//    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
//        print("Did receive message data")
//        NSKeyedUnarchiver.setClass(Activity.self, forClassName: "Activity")
//        NSKeyedUnarchiver.setClass(DataField.self, forClassName: "DataField")
//        NSKeyedUnarchiver.setClass(DataLayout.self, forClassName: "DataLayout")
//        NSKeyedUnarchiver.setClass(Goal.self, forClassName: "Goal")
//        NSKeyedUnarchiver.setClass(SettingsLayout.self, forClassName: "SettingsLayout")
//
//        guard let data = NSKeyedUnarchiver.unarchiveObject(with: messageData) else {
//            return
//        }
//
////        activities = data as! [Activity]
////        self.setupTableView()
//
//        NSKeyedArchiver.archiveRootObject(data as! [Activity], toFile: self.savePath)
//        setupTableView()
//        // Send a reply if wanted
//        //replyHandler([:])
//
//    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        print("File received!")
        let fm = FileManager.default
        let destURL = getDocumentsDirectory().appendingPathComponent("activities_file")
        
        do {
            if fm.fileExists(atPath: destURL.path) {
                //the file already exists - delete it!
                try fm.removeItem(at: destURL)
            }
            //copy the file from its temporary location
            try fm.copyItem(at: file.fileURL, to: destURL)
            
            //load the file and print it out
//            let contents = try String(contentsOf: destURL)
//            print(contents)
            
            setupTableView()
        } catch {
            //something went wrong!
            print("File copy failed")
        }
    }
}
