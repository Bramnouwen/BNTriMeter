//
//  OverviewController.swift
//  Watch Extension
//
//  Created by Bram Nouwen on 22/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import WatchKit
import HealthKit

class OverviewInterfaceController: WKInterfaceController {
    
    let wm = WorkoutManager.shared
    
    var goalId: Int!
    
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var overviewTable: WKInterfaceTable!
    
    @IBOutlet var startButton: WKInterfaceButton!
    @IBOutlet var startButtonLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("Awake")
        
        goalId = wm.activity?.goal?.id
        
        startButtonLabel.setText(L10n.Watch.Start.title)
        
        titleLabel.setText(wm.activity?.title)
        setupTableView()
        
    }
    
    func setupTableView() {
        guard let parts = wm.activity?.parts?.sorted(by: { $0.partId! < $1.partId! }) else { return }
        
        var rowTypes: [String] = []
        for part in parts {
            if part.title == L10n.Activity.Triathlon.transition {
                rowTypes.append("TransitionRow")
            } else {
                rowTypes.append("SportRow")
            }
        }
        
        overviewTable.setRowTypes(rowTypes)
        for (index, part) in parts.enumerated() {
            if part.title != L10n.Activity.Triathlon.transition {
                guard let controller = overviewTable.rowController(at: index) as? OverviewSportRowController else { return }
                controller.part = part
                
            } else {
                guard let controller = overviewTable.rowController(at: index) as? OverviewTransitionRowController else { return }
                controller.part = part
            }
        }
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
    
    @IBAction func startButtonClicked() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        wm.startWorkout(nil)
        
//        WKInterfaceController.reloadRootPageControllers(withNames: ["MenuController", "DuringSingleController", "PartsController"], contexts: nil, orientation: .horizontal, pageIndex: 1)
    }
    
    
}
