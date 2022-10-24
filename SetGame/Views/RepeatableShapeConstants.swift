//
//  RepeatableShapeConstants.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/24/22.
//

import Foundation

protocol RepeatableShapeConstants {
    static var pointFactors: [CGPoint] {get}
}

protocol CurvedRepeatableShapeConstants {
    static var controlFactors: [SegmentName: SegmentController] {get}
}

/// An enumeration naming the four possible segments of a Squiggle: upper, right, lower, and left;
/// each has the raw value of the index of the point in the points array where the segment ends,
/// which helps with iterating through drawing.
enum SegmentName: Int, CaseIterable {
    case upper = 1
    case right = 2
    case lower = 3
    case left = 0
}

/// A structure encapsulating the two control points for a segment of the squiggle. Can be stored, scaled, and moved as a
/// unit.
struct SegmentController {
    /// A Tuple containing the two control points for the segment
    let points: (control1: CGPoint, control2: CGPoint)
    
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
        SegmentController(points: (CGPoint(x: x1, y: y1),
                                   CGPoint(x: x2, y: y2)))
    }
    
    /// Creates and returns a copy of the receiver, both of whose control points have been scaled to the given CGSize
    /// - Parameter size: a CGSize for the new scale for the points
    /// - Returns: a SegmentController that is a copy of the receiver, scaled
    func scaled(to size: CGSize) -> SegmentController {
        let scaling = CGAffineTransform(scaleX: size.width, y: size.height)
        var newPoints: (control1: CGPoint, control2: CGPoint)
        
        newPoints = (control1: points.control1.applying(scaling),
                     control2: points.control2.applying(scaling))
        
        return SegmentController(points: newPoints)
    }
    
    /// Creates and returns a copy of the receiver, both of whose control points have been moved by the given CGPoint
    /// - Parameter size: a CGPoint for the distance to move the points
    /// - Returns: a SegmentController that is a copy of the receiver, moved
    func moved(by distance: CGPoint) -> SegmentController {
        let translation = CGAffineTransform(translationX: distance.x, y: distance.y)
        var newPoints: (control1: CGPoint, control2: CGPoint)
        
        newPoints = (control1: points.control1.applying(translation),
                     control2: points.control2.applying(translation))
        
        return SegmentController(points: newPoints)
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
