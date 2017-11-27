//
//  UIView+Extension.swift
//  TriMeter
//
//  Created by Bram Nouwen on 24/11/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import UIKit

let topColor = UIColor(red:0.09, green:0.13, blue:0.16, alpha:1.00)
let botColor = UIColor(red:0.04, green:0.07, blue:0.08, alpha:1.00)

extension UIView {
    
    func applyGradient() -> Void {
        self.applyGradient([topColor, botColor])
    }
    
    func applyGradient(_ colours: [UIColor]) -> Void {
        self.applyGradient(colours, locations: nil)
    }
    
    func applyGradient(_ colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.layer.bounds
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    
}
