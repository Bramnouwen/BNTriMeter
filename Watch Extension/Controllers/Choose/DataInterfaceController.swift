//
//  DataInterfaceController.swift
//  Watch Extension
//
//  Created by Bram Nouwen on 22/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import WatchKit
import HealthKit

class DataInterfaceController: WKInterfaceController {
    
    let wm = WorkoutManager.shared
    var goalId: Int!
    
    @IBOutlet var dataTable: WKInterfaceTable!
    var data: [DataField] = []
    
    @IBOutlet var startButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("Awake")
        
        goalId = wm.activity?.goal?.id
        
        startButton.setTitle(L10n.Tabs.start)
        
        setupTableView()
    }
    
    func setupTableView() {
        data = wm.activity!.getOrderedData() // TODO: Remove explicit?
        
        dataTable.setNumberOfRows(data.count, withRowType: "DataRow")
        
        for index in 0..<dataTable.numberOfRows {
            guard let controller = dataTable.rowController(at: index) as? DataRowController else { return }
            controller.dataField = data[index]
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
        
        wm.startWorkout()
        
//        WKInterfaceController.reloadRootPageControllers(withNames: ["MenuController", "DuringSingleController"], contexts: nil, orientation: .horizontal, pageIndex: 1)
    }
    
    
//    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
//        return wm.activity
//    }
}
