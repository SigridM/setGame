//
//  DiamondConstants.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 12/7/22.
//

import SwiftUI

/// A struct to encapsulate the constants for the Diamond drawing
struct DiamondConstants {
    
    /// points 0 and 2 are both in the center of the rect, half of the width
    private static let point0XFactor = 1.0 / 2.0
    private static let point2XFactor = 1.0 / 2.0
    
    /// points 1 and 3 are at the edges of the rect: all (100%) and none (0%) of the width, respectively
    private static let point1XFactor = 1.0
    private static let point3XFactor = 0.0
    
    /// points 1 and 3 are both in the middle of the rect, half the height.
    private static let point1YFactor = 1.0 / 2.0
    private static let point3YFactor = 1.0 / 2.0
    
    /// points 0 and 2 are a tiny bit away from the bottom and top, respectively, just so they aren't joined.
    private static let defaultHeight = 80.0
    private static let secondPointYInset = 1.0
    private static let point0YFactor = secondPointYInset / defaultHeight
    private static let point2YFactor = (defaultHeight - secondPointYInset) / defaultHeight
    
    /// An Array of the four points delineating the four segments of the diamond
    static var pointFactors = [
        CGPoint(x: point0XFactor, y: point0YFactor),
        CGPoint(x: point1XFactor, y: point1YFactor),
        CGPoint(x: point2XFactor, y: point2YFactor),
        CGPoint(x: point3XFactor, y: point3YFactor)
    ]
    
    static var segments: [Line] {
        var answer: [Line] = []
        let points = Self.pointFactors
        
        for pointIndex in points.indices {
            answer.append(
                Line(
                    startPoint: points[pointIndex],
                    endPoint: points[(pointIndex + 1) % points.count]
                )
            )
        }
        
        return answer
    }
}


