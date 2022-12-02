//
//  SegmentController.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/28/22.
//

import SwiftUI

/// A structure encapsulating the two control points for a segment of the squiggle. Can be stored, scaled, and moved as a
/// unit.
struct SegmentController {
    init(values: [Double]) {
        points.control1 = CGPoint(x:values[0], y: values[1])
        points.control2 = CGPoint(x:values[2], y: values[3])
    }
    
    var values: [Double] {
        get {
            [
                Double(points.control1.x),
                Double(points.control1.y),
                Double(points.control2.x),
                Double(points.control2.y)
            ]
        }
        set {
            points.control1.x = CGFloat(newValue[0])
            points.control1.y = CGFloat(newValue[1])
            points.control2.x = CGFloat(newValue[2])
            points.control2.y = CGFloat(newValue[3])
        }
    }

    static let numValues = 4
    
    static func points(_ newPoints: (control1: CGPoint, control2: CGPoint)) -> Self {
        return Self(values: [newPoints.control1.x, newPoints.control1.y,
                             newPoints.control2.x, newPoints.control2.y])
    }
    
    /// A Tuple containing the two control points for the segment
    var points: (control1: CGPoint, control2: CGPoint)
    
    /// A Factory method for creating and returning an instance of the SegmentController structure,
    /// created from its constituent x and y values for each of the two controls
    /// - Parameters:
    ///   - x1: a CGFloat for the x value of the first control
    ///   - y1: a CGFloat for the y value of the first control
    ///   - x2: a CGFloat for the x value of the second control
    ///   - y2: a CGFloat for the y value of the second control
    /// - Returns: a SegmentController containing the two control points
    static func from(x1: CGFloat, y1: CGFloat,
                     x2: CGFloat, y2: CGFloat) -> SegmentController {
        SegmentController(
            values: [
                Double(x1),
                Double(y1),
                Double(x2),
                Double(y2)
            ]
        )
    }
    
    /// Creates and returns a copy of the receiver, both of whose control points have been scaled to the given CGSize
    /// - Parameter size: a CGSize for the new scale for the points
    /// - Returns: a SegmentController that is a copy of the receiver, scaled
    func scaled(to size: CGSize) -> SegmentController {
        let scaling = CGAffineTransform(scaleX: size.width, y: size.height)
        var newPoints: (control1: CGPoint, control2: CGPoint)
        
        newPoints = (control1: points.control1.applying(scaling),
                     control2: points.control2.applying(scaling))
        
        return SegmentController.points(newPoints)
    }
    
    /// Creates and returns a copy of the receiver, both of whose control points have been moved by the given CGPoint
    /// - Parameter size: a CGPoint for the distance to move the points
    /// - Returns: a SegmentController that is a copy of the receiver, moved
    func moved(by distance: CGPoint) -> SegmentController {
        let translation = CGAffineTransform(translationX: distance.x, y: distance.y)
        var newPoints: (control1: CGPoint, control2: CGPoint)
        
        newPoints = (control1: points.control1.applying(translation),
                     control2: points.control2.applying(translation))
        
        return SegmentController.points(newPoints)
    }
    
    /// The first control point, a CGPoint
    var control1: CGPoint {
        return points.control1
    }
    
    /// The second control point, a CGPoint
    var control2: CGPoint {
        return points.control2
    }
    
}
