//
//  Haptic.swift
//  TriMeter
//
//  Created by Bram Nouwen on 20/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit
import AudioToolbox

class Haptic: NSObject {
    
    static let shared = Haptic()
    
    //    AudioServicesPlaySystemSound(1519) // Actuate `Peek` feedback (weak boom)
    //    AudioServicesPlaySystemSound(1520) // Actuate `Pop` feedback (strong boom)
    //    AudioServicesPlaySystemSound(1521) // Actuate `Nope` feedback (series of three weak booms)
    
    func light() {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        } else {
            AudioServicesPlaySystemSound(1519)
        }
    }
    
    func medium() {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        } else {
            AudioServicesPlaySystemSound(1520)
        }
    }
    
    func heavy() {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        } else {
            AudioServicesPlaySystemSound(1520)
        }
    }
    
    func error() {
        if #available(iOS 10.0, *) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        } else {
            AudioServicesPlaySystemSound(1521)
        }
    }
    
    func success() {
        if #available(iOS 10.0, *) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } else {
            AudioServicesPlaySystemSound(1519)
            delayWithSeconds(0.1, completion: {
                AudioServicesPlaySystemSound(1520)
            })
        }
    }
    
    func warning() {
        if #available(iOS 10.0, *) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
}

