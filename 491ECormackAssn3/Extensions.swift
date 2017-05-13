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
