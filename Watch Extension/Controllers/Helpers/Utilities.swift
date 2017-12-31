//
//  Utilities.swift
//  Watch Extension
//
//  Created by Bram Nouwen on 29/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import Foundation
import HealthKit

// MARK: Formatters for data

// Duration
func calculateTimeIntervalBetween(startDate: Date, endDate: Date) -> TimeInterval {
    return Date().timeIntervalSince(startDate)
}

func format(totalDuration: TimeInterval) -> String {
    let durationFormatter = DateComponentsFormatter()
    durationFormatter.unitsStyle = .positional
    durationFormatter.allowedUnits = [.second, .minute, .hour]
    durationFormatter.zeroFormattingBehavior = .pad
    
    if let string = durationFormatter.string(from: totalDuration) {
        return string
    } else {
        return ""
    }
}

// Distance
func format(totalDistance: Double) -> String {
    let kilometers = totalDistance / 1000
    let formattedKilometers = String(format: "%.2f", kilometers)
    
    return formattedKilometers
}

//HKWorkout
func format(totalDistance: HKQuantity?) -> String {
    return format(totalDistance: totalDistance?.doubleValue(for: .meter()) ?? 0)
}

// Calories
func format(totalEnergyBurned: Double) -> String {
    let formattedKiloCalories = String(format: "%.f", totalEnergyBurned)
    
    return formattedKiloCalories
}

//HKWorkout
func format(totalEnergyBurned: HKQuantity?) -> String {
    return format(totalEnergyBurned: totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0)
}

// HeartRate
func format(lastHeartRate: Int) -> String {
    return "\(lastHeartRate)"
}

// Steps
func format(totalSteps: Double) -> String {
    let formattedSteps = String(Int(totalSteps))
    
    return formattedSteps
}

