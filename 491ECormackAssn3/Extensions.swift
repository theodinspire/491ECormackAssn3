//
//  Utilities.swift
//  491ECormackAssn3
//
//  Created by Eric Cormack on 5/12/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

extension CGVector {
    var magnitude: CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
    
    init(_ point: CGPoint) {
        dx = point.x
        dy = point.y
    }
}

extension UIPushBehavior {
    convenience init(mode: UIPushBehaviorMode) {
        self.init(items: [], mode: mode)
    }
}

extension UIColor {
    func blend(with color: UIColor, ratio: CGFloat) -> UIColor {
        let that: CGFloat
        if ratio >= 1 { that = 1 }
        else if ratio <= 0 { that = 0 }
        else { that = ratio }
        
        let this = 1 - that
        
        var thisR: CGFloat = 0
        var thisG: CGFloat = 0
        var thisB: CGFloat = 0
        var thisA: CGFloat = 0
        getRed(&thisR, green: &thisG, blue: &thisB, alpha: &thisA)
        
        var thatR: CGFloat = 0
        var thatG: CGFloat = 0
        var thatB: CGFloat = 0
        var thatA: CGFloat = 0
        color.getRed(&thatR, green: &thatG, blue: &thatB, alpha: &thatA)
        
        let red = this * thisR + that * thatR
        let green = this * thisG + that * thatG
        let blue = this * thisB + that * thatB
        let alpha = this * thisA + that * thatA
        
        return UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
    }
}
