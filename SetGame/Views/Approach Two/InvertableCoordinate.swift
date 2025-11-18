//
//  InvertableCoordinate.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 12/6/22.
//

import SwiftUI

struct InvertableCoordinate {
    let reflectiveSurface: CGFloat
    let reflectionDistance: CGFloat
    
    func valueIn(_ direction: Double) -> CGFloat {
        reflectiveSurface + (reflectionDistance * direction)
    }
}

struct InvertablePoint {
    let x: InvertableCoordinate
    let y: InvertableCoordinate
    
    func inDirection(_ direction: Double) -> CGPoint {
        CGPoint(
            x: x.valueIn(direction),
            y: y.valueIn(direction)
        )
    }
}

struct InvertableControlPoints {
    let first: InvertablePoint
    let second: InvertablePoint
    
    func inDirection(_ direction: Double) -> (first: CGPoint, second: CGPoint) {
        (first: first.inDirection(direction),
         second: second.inDirection(direction)
        )
    }
}

struct InvertableCurve {
    let startPoint: InvertablePoint
    let endPoint: InvertablePoint
    let controlPoints: InvertableControlPoints
    
    func addTo(path: inout Path, in direction: Double) {
        
        path.addCurve(to: endPoint.inDirection(direction),
                      control1: controlPoints.inDirection(direction).first,
                      control2: controlPoints.inDirection(direction).second
                      )
    }
}
