//
//  Segment.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 12/6/22.
//

import SwiftUI

///
protocol Segment: Shape {
    
    /// The points that make up the endpoints of the shape, represented as fractions of a unit so they can be scaled to the
    /// enclosing rectangle
    var startPoint: CGPoint {get set}
    var endPoint: CGPoint {get set}
    
    /// An opportunity for the implementer of this protocol to initialize any instance variables
    init()
    
}

extension Segment {
    
    init(startPoint: CGPoint, endPoint: CGPoint) {
        self.init()
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    func startPointScaled(to size: CGSize) -> CGPoint {
        let scaling = CGAffineTransform(scaleX: size.width, y: size.height)
        return startPoint.applying(scaling)
    }
    
    func endPointScaled(to size: CGSize) -> CGPoint {
        let scaling = CGAffineTransform(scaleX: size.width, y: size.height)
        return endPoint.applying(scaling)
    }
    
    func scaled(to size: CGSize) -> Self {
        Self(startPoint: startPointScaled(to: size), endPoint: endPointScaled(to: size))
    }
    
    func moved(by distance: CGPoint) -> Self {
        Self(startPoint: startPoint.moved(by: distance), endPoint: endPoint.moved(by: distance))
    }
    
    /// Adds the receiver to the given path
    /// - Parameters:
    ///   - path: the Path that will be modified to include the new segment
    func add(to path: inout Path) {
        print("StartPoint: \(startPoint)")
        path.move(to: startPoint)
        path.addLine(to: endPoint)
    }

}


//extension UnitPoint {
//    func applying(_ transform: CGAffineTransform) -> CGPoint {
//        CGPoint(x: x, y: y).applying(transform)
//    }
//}
