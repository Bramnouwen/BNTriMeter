//
//  settingsLayout.swift
//  TriMeter
//
//  Created by Bram Nouwen on 7/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit

class SettingsLayout: NSObject, NSCoding {
    
    //var id: Int?
    //var defaultFor: Int?
    var audio: Bool
    var autopause: Bool
    var countdown: Bool
    var countdownAmount: Int
    var haptic: Bool
    var liveLocation: Bool
    
    init(audio: Bool,
                  autopause: Bool,
                  countdown: Bool,
                  countdownAmount: Int,
                  haptic: Bool,
                  liveLocation: Bool) {
        
        self.audio = audio
        self.autopause = autopause
        self.countdown = countdown
        self.countdownAmount = countdownAmount
        self.haptic = haptic
        self.liveLocation = liveLocation
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(audio, forKey: "audio")
        aCoder.encode(autopause, forKey: "autopause")
        aCoder.encode(countdown, forKey: "countdown")
        aCoder.encode(countdownAmount, forKey: "countdownAmount")
        aCoder.encode(haptic, forKey: "haptic")
        aCoder.encode(liveLocation, forKey: "liveLocation")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let audio = aDecoder.decodeBool(forKey: "audio")
        let autopause = aDecoder.decodeBool(forKey: "autopause")
        let countdown = aDecoder.decodeBool(forKey: "countdown")
        let countdownAmount = aDecoder.decodeInteger(forKey: "countdownAmount")
        let haptic = aDecoder.decodeBool(forKey: "haptic")
        let liveLocation = aDecoder.decodeBool(forKey: "liveLocation")
        
        self.init(audio: audio, autopause: autopause, countdown: countdown, countdownAmount: countdownAmount, haptic: haptic, liveLocation: liveLocation)
    }
}
