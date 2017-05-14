//
//  Direction.swift
//  491ECormackAssn3
//
//  Created by Eric Cormack on 5/13/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

enum Direction {
    case Up, Right, Down, Left
    
    var opposite: Direction {
        switch self {
        case .Up:
            return .Down
        case .Right:
            return .Left
        case .Down:
            return .Up
        case .Left:
            return .Right
        }
    }
    
    static func random() -> Direction {
        switch arc4random_uniform(4) {
        case 0:
            return .Up
        case 1:
            return .Right
        case 2:
            return .Down
        case 3:
            return .Left
        default:
            return .Up
        }
    }
    
    var isUpDown: Bool { return self == .Up || self == .Down }
}
