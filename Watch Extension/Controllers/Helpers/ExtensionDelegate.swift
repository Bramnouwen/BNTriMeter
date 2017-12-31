//
//  ExtensionDelegate.swift
//  Watch Extension
//
//  Created by Bram Nouwen on 20/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import WatchKit
import HealthKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        requestAuthorization()
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
    func handle(_ workoutConfiguration: HKWorkoutConfiguration) {
        WorkoutManager.shared.startWorkout(workoutConfiguration)
    }

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
                                            HKObjectType.quantityType(forIdentifier: .heartRate)!,
                                            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                            HKObjectType.quantityType(forIdentifier: .stepCount)!,
                                            HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                                            HKObjectType.quantityType(forIdentifier: .distanceSwimming)!,
                                            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                            HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount)!]
        
        // Create health store
        let healthStore = HKHealthStore()
        
        // Use it to request authorization for our types
        healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { (success, error) in
            if success {
                print("Success: authorization granted")
            } else {
                print("Error: \(error?.localizedDescription ?? "")")
            }
        }
    }
}
