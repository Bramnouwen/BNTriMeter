//
//  WorkoutManager.swift
//  Watch Extension
//
//  Created by Bram Nouwen on 29/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//
/* Referenced
 - https://stackoverflow.com/questions/46835438/how-to-save-an-array-of-hkquantitysamples-heart-rate-to-a-workout?rq=1
 - https://myswimpro.com/blog/2016/11/09/building-a-workout-app-for-apple-watch/
 
 */

import WatchKit
import HealthKit
import CoreLocation

class WorkoutManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = WorkoutManager()
    
    var activity: Activity?
    var currentPart = 0
    
    var hkActivity: HKWorkoutActivityType!
    
    var healthStore = HKHealthStore()
    
    var distanceType: HKQuantityTypeIdentifier = .distanceCycling
    
    var workoutStartDate = Date() {
        didSet {
            print("Start date set: \(workoutStartDate)")
        }
    }
    var workoutEndDate = Date() {
        didSet {
            print("End date set: \(workoutEndDate)")
        }
    }
    var cumulativePauseTime: TimeInterval = 0.0
    var pauseDate = Date()
    
    var activeDataQueries: [HKQuery] = []
    
    var workoutSession: HKWorkoutSession?
    var workoutIsActive = true
    
    var workoutRouteBuilder: HKWorkoutRouteBuilder!
    var locationManager: CLLocationManager!
    
    // Data
    var totalEnergyBurned = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 0)
    var totalDistance = HKQuantity(unit: HKUnit.meter(), doubleValue: 0)
    var totalSteps = HKQuantity(unit: HKUnit.count(), doubleValue: 0)
    var lastHeartRate = 0.0
    let countPerMinuteUnit = HKUnit(from: "count/min")
    
    var workoutObject: HKWorkout? //TODO: Delete, probably
    var workoutObjects: [HKWorkout] = []
    
    func resetData() {
        totalEnergyBurned = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 0)
        totalDistance = HKQuantity(unit: HKUnit.meter(), doubleValue: 0)
        totalSteps = HKQuantity(unit: HKUnit.count(), doubleValue: 0)
        lastHeartRate = 0.0
        cumulativePauseTime = 0.0
        //workoutSession?
        //workoutIsActive?
        //workoutRouteBuilder?
        //locationManager?
    }
    
    var timer: Timer?
    
    override init() {
        super.init()
        
        
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
            guard let samples = samples as? [HKQuantitySample] else {
                print("Error: \(error!.localizedDescription)")
                return
            }
            
            //process the samples
            self.process(samples, type: quantityTypeIdentifier)
        }
        
        // Create the query out of our type (e.g. heart rate), predicate and result handling code
        let quantityType = HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!
        let query = HKAnchoredObjectQuery(type: quantityType, predicate: queryPredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        // Tell HealthKit to re-run the code every time new data is available
        query.updateHandler = updateHandler
        
        // Start the query running
        healthStore.execute(query)
        
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
                print("Total steps: \(totalSteps)")
            } else {
                print("Something else: sample undetermined")
            }
        }
        
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateLabels"), object: self)
    }
    
    func cleanUpQueries() {
        // Stop queries
        for query in activeDataQueries {
            healthStore.stop(query)
        }
        activeDataQueries.removeAll()
        // and location
        if locationManager != nil {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func startQueries() {
        // Start queries
        startQuery(distanceType)
        startQuery(.activeEnergyBurned)
        startQuery(.heartRate) // TODO: only if heartrate is enabled for swimming
        if hkActivity! == .swimming {
            print("Querying swimming stroke count")
            startQuery(.swimmingStrokeCount)
        } else {
            print("Querying steps")
            startQuery(.stepCount)
        }
        // and location
        startAccumulatingLocationData()
        WKInterfaceDevice.current().play(.start)
    }
    
    // MARK: - Workout functions
    
    func startWorkout(_ configuration: HKWorkoutConfiguration?) {
        resetData()
        var workoutConfiguration = HKWorkoutConfiguration()
        if configuration == nil {
            // 0 - get workout activity type
            let workoutActivityType = getActivityType()
            // 1 - create a workout configuration()
            workoutConfiguration = HKWorkoutConfiguration()
            workoutConfiguration.activityType = workoutActivityType
            workoutConfiguration.locationType = .outdoor // TODO: Select in settings
            if workoutActivityType == .swimming {
                //set open water swimming location if we're swiming
                workoutConfiguration.swimmingLocationType = .openWater
            }
        } else {
            workoutConfiguration = configuration!
            hkActivity = workoutConfiguration.activityType
        }
        
        // 2 - create a workout session from that
        if let session = try? HKWorkoutSession(configuration: workoutConfiguration) {
            workoutSession = session
            // 3 - start the workout now
            healthStore.start(session)
            // 4 - reset our start date
            workoutStartDate = Date()
            // 5 - register to receive status updates
            session.delegate = self
            // 6 - show controllers
            loadControllers()
        }
    }
    
    func stopWorkout() -> Bool {
        workoutEndDate = Date()
        timer?.invalidate()
        healthStore.end(workoutSession!)
        workoutObject = createHKWorkout()
        guard let workoutObject = workoutObject else {
            print("Error creating workoutObject")
            return false
        }
        save(workout: workoutObject)
        workoutObjects.append(workoutObject)
        return true
    }
    
    func loadControllers() {
        var controllers: [String] = []
        if activity?.parts?.count == 0 {
            controllers = ["MenuController", "DuringSingleController"]
        } else {
            controllers = ["MenuController", "DuringSingleController", "PartsController"]
        }
        WKInterfaceController.reloadRootPageControllers(withNames: controllers, contexts: nil, orientation: .horizontal, pageIndex: 1)
    }
    
    func getActivityType() -> HKWorkoutActivityType {
        if let activity = activity {
            if !activity.isPreset {
                //no preset, get the activity type
                hkActivity = activity.healthKitWorkoutActivityType()
            } else if let parts = activity.parts {
                //preset, get activity type of current part
                hkActivity = parts[currentPart].healthKitWorkoutActivityType()
            }
        }
        
        // And set distancetype
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
    
    func activityHasNextPart() -> Bool {
        guard let activity = activity, let parts = activity.parts else { return false }
        let indices = parts.indices
        
        if indices.contains(currentPart + 1) {
            //we have another part
            return true
        } else {
            //we don't
            return false
        }
    }
    
    // Create HKWorkout
    
    func createHKWorkout() -> HKWorkout {
        var workout: HKWorkout?
        if let workoutSession = workoutSession {
            let config = workoutSession.workoutConfiguration
            
            // TODO: If preset -> save info as metadata
            workout = HKWorkout(activityType: config.activityType,
                                start: workoutStartDate,
                                end: workoutEndDate,
                                workoutEvents: nil,
                                totalEnergyBurned: totalEnergyBurned,
                                totalDistance: totalDistance,
                                metadata: [HKMetadataKeyIndoorWorkout: false])
        }
        
        return workout!
    }
    
    // Save activity
    
    func save(workout: HKWorkout) {
        //var returnBool = false
//        guard let workoutSession = workoutSession else { return }
//
//        let config = workoutSession.workoutConfiguration
//        let workout = HKWorkout(activityType: config.activityType,
//                                start: workoutStartDate,
//                                end: workoutEndDate,
//                                workoutEvents: nil,
//                                totalEnergyBurned: totalEnergyBurned,
//                                totalDistance: totalDistance,
//                                metadata: [HKMetadataKeyIndoorWorkout: false])
        
        healthStore.save(workout) { (success, error) in
            if success {
                self.addSamples(toWorkout: workout, from: self.workoutStartDate, to: self.workoutEndDate)
            } else {
                // TODO: Show error alert
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
    
    private func addSamples(toWorkout workout: HKWorkout, from startDate: Date, to endDate: Date) {
        // Create energy sample
        let typeEnergy = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        let totalEnergyBurnedSample = HKQuantitySample(type: typeEnergy,
                                                       quantity: totalEnergyBurned,
                                                       start: startDate,
                                                       end: endDate.addingTimeInterval(1)) //TODO: delete addingTimeInterval
        // Create distance sample
        let typeDistance = HKObjectType.quantityType(forIdentifier: distanceType)!
        let totalDistanceSample = HKQuantitySample(type: typeDistance,
                                                   quantity: totalDistance,
                                                   start: startDate,
                                                   end: endDate.addingTimeInterval(1)) //TODO: delete addingTimeInterval
        // Create heartrate sample
//        let typeHeartRAte = HKObjectType.quantityType(forIdentifier: .heartRate)
        
        // Create samples array
        var samples = [HKQuantitySample]()
        samples.append(totalEnergyBurnedSample)
        samples.append(totalDistanceSample)
//        samples.append(contentsOf: heartRateValues) // TODO: Create own array
        
        // Add samples to workout
        healthStore.add(samples, to: workout) { (success: Bool, error: Error?) in
            guard success else {
                print("Adding workout subsamples failed with error: \(String(describing: error))")
                return
            }
//            self.resetData()
        }
        
        // Finish the route with a sync identifier so we can easily update the route later
        var metadata = [String: Any]()
        metadata[HKMetadataKeySyncIdentifier] = UUID().uuidString
        metadata[HKMetadataKeySyncVersion] = NSNumber(value: 1)

        workoutRouteBuilder?.finishRoute(with: workout, metadata: metadata) { (workoutRoute, error) in
            if workoutRoute == nil {
                print("Finishing route failed with error: \(String(describing: error))")
            }
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let filteredLocations = locations.filter { (location: CLLocation) -> Bool in
            location.horizontalAccuracy <= kCLLocationAccuracyNearestTenMeters
        }
        
        guard !filteredLocations.isEmpty else { return }
        
        workoutRouteBuilder.insertRouteData(filteredLocations) { (success, error) in
            if !success {
                print("inserting route data failed with error: \(String(describing: error))")
            }
        }
    }
    
    func startAccumulatingLocationData() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("User does not have location services enabled")
            return
        }
        
        DispatchQueue.main.async {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.allowsBackgroundLocationUpdates = true
            self.locationManager.startUpdatingLocation()
        }
        
        workoutRouteBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: nil)
    }
    
    /* Unused
     Example to fetch a day's energy consumed with a statistics query
     */
//    func fetchDietaryEnergyConsumedWithCompletionHandler(
//        completionHandler:@escaping (Double?, Error?)->()) {
//
//        let sampleType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)
//
//        let datePredicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictStartDate)
//        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
//        let queryPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, devicePredicate])
//
//        let query = HKStatisticsQuery(quantityType: sampleType!,
//                                      quantitySamplePredicate: queryPredicate,
//                                      options: .cumulativeSum) { query, result, error in
//
//                                        if result != nil {
//                                            completionHandler(nil, error)
//                                            return
//                                        }
//
//                                        var totalCalories = 0.0
//
//                                        if let quantity = result?.sumQuantity() {
//                                            let unit = HKUnit.joule()
//                                            totalCalories = quantity.doubleValue(for: unit)
//                                        }
//
//                                        completionHandler(totalCalories, error)
//        }
//
//        healthStore.execute(query)
//    }
    
}

// MARK: - Workout session delegate

extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("Workout state changed")
        switch toState {
        case .running:
            print("Current state: running")
            if fromState == .notStarted {
                startQueries()
                workoutIsActive = true
            } else {
                workoutIsActive = true
            }
        case .paused:
            print("Current state: paused")
            workoutIsActive = false
        case .ended:
            print("Current state: ended")
            workoutIsActive = false
            cleanUpQueries()
            
        default:
            break
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
        if event.type == .pauseOrResumeRequest {
            print("Starting next part")
            guard activityHasNextPart() else {
                if stopWorkout() {
                    DispatchQueue.main.async {
                        WKInterfaceController.reloadRootPageControllers(withNames: ["AfterController"], contexts: nil, orientation: .horizontal, pageIndex: 0)
                    }
                }
                return
            }
            
            if stopWorkout() {
                currentPart += 1
                startWorkout(nil)
            }
        }
    }
    
}
/*
 Ik ga gewoon een paar zinnen schrijven
 seffens nog de wieleroutfit en koersfiets halen bij tom
 absoluut geen zin in, kan wel een safke roken dan
 zaterdag
 */
