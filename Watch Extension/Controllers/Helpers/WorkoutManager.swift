//
//  WorkoutManager.swift
//  Watch Extension
//
//  Created by Bram Nouwen on 29/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import WatchKit
import HealthKit

class WorkoutManager: NSObject {
    
    static let shared = WorkoutManager()
    
    var activity: Activity?
    
    var hkActivity: HKWorkoutActivityType!
    var healthStore: HKHealthStore?
    var distanceType = HKQuantityTypeIdentifier.distanceCycling
    var workoutStartDate = Date()
    var workoutEndDate = Date()
    var activeDataQueries: [HKQuery] = []
    var workoutSession: HKWorkoutSession?
    var workoutIsActive = true
    var workoutPaused = false
    
    // Data
    var totalEnergyBurned = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 0)
    var totalDistance = HKQuantity(unit: HKUnit.meter(), doubleValue: 0)
    var totalSteps = HKQuantity(unit: HKUnit.count(), doubleValue: 0)
    var lastHeartRate = 0.0
    let countPerMinuteUnit = HKUnit(from: "count/min")
    
    override init() {
        super.init()
        
        requestAuthorization()
        
    }
    
    // MARK: - Query functions
    
    func startQuery(_ quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        // We only want data points after our workout start date
        let datePredicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictStartDate)
        // And from our current device
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        // Combine them
        let queryPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, devicePredicate])
        // Write code to receive results from our query
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = { query, samples, deletedObjects, queryAnchor, error in
            
            //safely typecast to a quantity sample so we can read values
            guard let samples = samples as? [HKQuantitySample] else { return }
            
            //process the samples
            self.process(samples, type: quantityTypeIdentifier)
        }
        
        // Create the query out of our type (e.g. heart rate), predicate and result handling code
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: queryPredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        // Tell HealthKit to re-run the code every time new data is available
        query.updateHandler = updateHandler
        
        // Start the query running
        healthStore?.execute(query)
        
        // Stach it away so we can stop it later
        activeDataQueries.append(query)
    }
    
    func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        // Ignore updates while we are paused
        guard workoutIsActive else { return }
        // Loop over all the samples we've been sent
        for sample in samples {
            // Calories
            if type == .activeEnergyBurned {
                let unit = HKUnit.kilocalorie()
                let newEnergy = sample.quantity.doubleValue(for: unit)
                let currentEnergy = totalEnergyBurned.doubleValue(for: unit)
                totalEnergyBurned = HKQuantity(unit: unit, doubleValue: currentEnergy + newEnergy)
                print("Total energy: \(totalEnergyBurned)")
            } else if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: countPerMinuteUnit)
                print("Last heart rate: \(lastHeartRate)")
            } else if type == distanceType {
                let newDistance = sample.quantity.doubleValue(for: HKUnit.meter())
                let currentDistance = totalDistance.doubleValue(for: HKUnit.meter())
                totalDistance = HKQuantity(unit: HKUnit.meter(), doubleValue: currentDistance + newDistance)
                print("Total distance: \(totalDistance)")
            } else if type == .stepCount {
                let newSteps = sample.quantity.doubleValue(for: HKUnit.count())
                let currentSteps = totalSteps.doubleValue(for: HKUnit.count())
                totalSteps = HKQuantity(unit: HKUnit.count(), doubleValue: currentSteps + newSteps)
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateDataLabels"), object: self)
    }
    
    func cleanUpQueries() {
        for query in activeDataQueries {
            healthStore?.stop(query)
        }
        activeDataQueries.removeAll()
    }
    
    func startQueries() {
        startQuery(distanceType)
        startQuery(.activeEnergyBurned)
        startQuery(.heartRate) // TODO: only if heartrate is enabled for swimming
        if hkActivity! == .swimming {
            startQuery(.swimmingStrokeCount)
        } else {
            startQuery(.stepCount)
        }
        
        WKInterfaceDevice.current().play(.start)
    }
    
    // MARK: - Workout functions
    
    func startWorkout() {
        // 0 - get workout activity type
        let workoutDistanceType = setDistanceType()
        
        // 1 - create a workout configuration()
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = workoutDistanceType
        workoutConfiguration.locationType = .outdoor // TODO: Select in settings
        if workoutDistanceType == .swimming {
            //set open water swimming location if we're swiming
            workoutConfiguration.swimmingLocationType = .openWater
        }
        
        // 2 - create a workout session from that
        if let session = try? HKWorkoutSession(configuration: workoutConfiguration) {
            workoutSession = session
            // 3 - start the workout now
            healthStore?.start(session)
            // 4 - reset our start date
            workoutStartDate = Date()
            // 5 - register to receive status updates
            session.delegate = self
            // 6 - show controllers
            var controllers: [String] = []
            if activity?.parts?.count == 0 {
                controllers = ["MenuController", "DuringSingleController"]
            } else {
                 controllers = ["MenuController", "DuringSingleController", "PartsController"]
            }
            WKInterfaceController.reloadRootPageControllers(withNames: controllers, contexts: nil, orientation: .horizontal, pageIndex: 1)
        }
    }
    
    func setDistanceType() -> HKWorkoutActivityType {
        if activity?.parts?.count == 0 {
            hkActivity = activity?.healthKitWorkoutActivityType()
        } else {
            hkActivity = activity?.parts![0].healthKitWorkoutActivityType()
        }
        
        switch hkActivity {
        case .walking, .running:
            distanceType = .distanceWalkingRunning
        case .cycling:
            distanceType = .distanceCycling
        case .swimming:
            distanceType = .distanceSwimming
        default:
            distanceType = .distanceWheelchair
        }
        
        return hkActivity
    }
    
    
    // Mark: - HealthKit authorization
    
    func requestAuthorization() {
        // Configure write values
        let writeTypes: Set<HKSampleType> = [.workoutType(),
                                             HKSampleType.quantityType(forIdentifier: .heartRate)!,
                                             HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                             HKSampleType.quantityType(forIdentifier: .stepCount)!,
                                             HKSampleType.quantityType(forIdentifier: .distanceCycling)!,
                                             HKSampleType.quantityType(forIdentifier: .distanceSwimming)!,
                                             HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                             HKSampleType.quantityType(forIdentifier: .swimmingStrokeCount)!]
        // Configure read values
        let readTypes: Set<HKObjectType> = [.activitySummaryType(), .workoutType(),
                                            HKSampleType.quantityType(forIdentifier: .heartRate)!,
                                            HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                            HKSampleType.quantityType(forIdentifier: .stepCount)!,
                                            HKSampleType.quantityType(forIdentifier: .distanceCycling)!,
                                            HKSampleType.quantityType(forIdentifier: .distanceSwimming)!,
                                            HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                            HKSampleType.quantityType(forIdentifier: .swimmingStrokeCount)!]
        // Create health store
        healthStore = HKHealthStore()
        
        // Use it to request authorization for our types
        healthStore?.requestAuthorization(toShare: writeTypes, read: readTypes, completion: { (success, error) in
            if success {
                print("Success: authorization granted")
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        })
    }
}

extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch toState {
        case .running:
            if fromState == .notStarted {
                startQueries()
            } else {
                workoutIsActive = true
            }
        case .paused:
            workoutIsActive = false
        case .ended:
            workoutIsActive = false
            cleanUpQueries()
            DispatchQueue.main.async {
                WKInterfaceController.reloadRootPageControllers(withNames: ["AfterController"], contexts: nil, orientation: .horizontal, pageIndex: 0)
            }
        default:
            break
        }
    }
}
