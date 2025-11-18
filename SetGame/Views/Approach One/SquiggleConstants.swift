//
//  SquiggleConstants.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 11/30/22.
//

import Foundation
/// A struct to encapsulate the constants for the Squiggle drawing
struct SquiggleConstants {
    /// Because the original squiggle was drawn in a 60x20 rectangle, all inset calculations are
    /// based proportionally on that original grid, as if it was a 1x1 square. The insets are
    /// later scaled by the dimensions of a circumscribing rectangle to fit that rectangle.
    private static let defaultWidth = 60.0
    private static let defaultHeight = 20.0
    
    private static let center = 0.5
    
    private static let verticalPointReflectiveDistance = 0.1

    private static let upperReflectivePoint = center - verticalPointReflectiveDistance
    private static let lowerReflectivePoint = center + verticalPointReflectiveDistance
    
    private static let distanceFromReflectivePoint = 0.2
    
    /// A direction of 1.0 will define a squiggle that points down on the left; a direction of -1.0 defines a squiggle that points up on the
    /// left.
    let direction = 1.0

    /// Returns the endpoints of each segment, starting from the upper left and moving clockwise around the shape, expressed
    /// in unit points (fractions of 1).
    func pointFactors() -> [CGPoint] {
        [
            CGPoint(
                x: Self.leftmostXFactor,
                y: Self.upperReflectivePoint + Self.distanceFromReflectivePoint * direction
            ),
            CGPoint(
                x: Self.rightmostXFactor,
                y: Self.upperReflectivePoint - Self.distanceFromReflectivePoint * direction
            ),
            CGPoint(
                x: Self.rightmostXFactor,
                y: Self.lowerReflectivePoint - Self.distanceFromReflectivePoint * direction
            ),
            CGPoint(
                x: Self.leftmostXFactor,
                y: Self.lowerReflectivePoint + Self.distanceFromReflectivePoint * direction
            )
        ]
    }
    
    
    
    /// All points are the same distance from the left and right edges, counted from 0 clockwise from the upper left
    private static let xFromCenter = 0.4
    private static let leftmostXFactor = center - xFromCenter
    private static let rightmostXFactor = center + xFromCenter
    

    /// An Array of the four points delineating the four segments of a squiggle that points down on the left side. These are
    /// arrayed starting from the upper left of the squiggle and moving clockwise around the squiggle: left-center, right-high,
    /// right-center, left-low.
    static var downLeftPointFactors = [
        CGPoint(
            x: leftmostXFactor,
            y: upperReflectivePoint + distanceFromReflectivePoint
        ),
        CGPoint(
            x: rightmostXFactor,
            y: upperReflectivePoint - distanceFromReflectivePoint
        ),
        CGPoint(
            x: rightmostXFactor,
            y: lowerReflectivePoint - distanceFromReflectivePoint
        ),
        CGPoint(
            x: leftmostXFactor,
            y: lowerReflectivePoint + distanceFromReflectivePoint
        )
    ]
    
    /// An Array of the four points delineating the four segments of a squiggle that points up on the left side. These are
    /// arrayed starting from the upper left of the squiggle and moving clockwise around the squiggle: left-high, right-center,
    /// right-low, left-center.
    static var upLeftPointFactors = [
        CGPoint(
            x: leftmostXFactor,
            y: upperReflectivePoint - distanceFromReflectivePoint
        ),
        CGPoint(
            x: rightmostXFactor,
            y: upperReflectivePoint + distanceFromReflectivePoint
        ),
        CGPoint(
            x: rightmostXFactor,
            y: lowerReflectivePoint + distanceFromReflectivePoint
        ),
        CGPoint(
            x: leftmostXFactor,
            y: lowerReflectivePoint - distanceFromReflectivePoint
        )
    ]
    

    /// control points for the high hump of the upper curve, and the low dip of the lower
    /// curve, are equal distances above and below the top and bottom edges, respectively
    private static let outerControlYInset = -15.0
    private static let aboveTheTop = outerControlYInset / defaultHeight
    private static let belowTheBottom = (defaultHeight - outerControlYInset) / defaultHeight
    
    /// control points for the low dip of the upper curve, and the high hump of the lower
    /// curve, are equal distances below and above the bottom and top edges, respectively
//    private static let innerControlYInset = outerControlYInset + 15
    private static let bottom = 1.0 // (defaultHeight - innerControlYInset) / defaultHeight
    private static let top = 0.0 // innerControlYInset / defaultHeight
    
    /// control points for the inner parts of the left and right endcaps are the same distance
    /// from the left and right edges, respectively
    private static let innerEndCapXInset = 2.0
    private static let leftCapControl1XFactor = innerEndCapXInset / defaultWidth
    private static let rightCapControl1XFactor = (defaultWidth - innerEndCapXInset) / defaultWidth
    
    /// control points for the outer parts of the right and left endcaps are the same distance
    /// outside the right and left edges, respectively
    private static let outerEndCapXInset = -1.0
    private static let rightCapControl2XFactor = (defaultWidth - outerEndCapXInset) / defaultWidth
    private static let leftCapControl2XFactor = outerEndCapXInset / defaultWidth
    
    /// control points for the highest and lowest parts of the right and left endcaps, respectively
    /// are the same distance above and below the top and bottom edges, respectively
    private static let innerEndCapYInset = 2.0
    private static let belowTop = innerEndCapYInset / defaultHeight  // 1/20
    
    /// control points for the closer parts of the right and left endcaps are the same distance
    /// inside the top and bottom edges, respectively
    private static let outerEndCapYInset = -0.5
    private static let aboveBottom = (defaultHeight - outerEndCapYInset) / defaultHeight  // 19.5/20
    
    private static let lowerControlReflectivePoint = (belowTop + aboveBottom) / 2 // 20.5/40
    private static let verticalControlReflectiveDistance = lowerControlReflectivePoint - belowTop // 19.5/40
    private static let upperControlReflectivePoint = bottom - lowerControlReflectivePoint

    
    /// A Dictionary of two-point SegmentControllers, stored by their SquiggleName for readability, for a squiggle that
    /// points down at the left side. The curves are drawn beginning from the upper left side, moving clockwise.
    static var downLeftControlFactors: [FourPartSegmentName: SegmentController] = [
       .upper: (SegmentController.from(
            /// The first control point of the upper curve pulls its hump up a lot and to the center
            x1: center,
            y1: aboveTheTop,
            /// The second control point of the upper curve pulls its dip down a little and to the center
            x2: center,
            y2: bottom)
       ),
        .right: (SegmentController.from(
            /// The first control point of the right endcap pulls its curve up and a little to the right
            x1: rightCapControl1XFactor,
            y1: upperControlReflectivePoint - verticalControlReflectiveDistance,
            /// The second control point of the right endcap pulls its curve slightly less high but farther to the right
            x2: rightCapControl2XFactor,
            y2: lowerControlReflectivePoint - verticalControlReflectiveDistance)
        ),
        .lower: (SegmentController.from(
            /// The first (continuing to move clockwise) control point of the lower curve pulls its dip down a lot and to the center
            x1: center,
            y1: belowTheBottom,
            /// The second control point of the lower curve pulls its hump up a little and to the center
            x2: center,
            y2: top)
        ),
        .left: (SegmentController.from(
            /// The first (countinuing to move clockwise) control point of the left endcap pulls its curve down and a little to the left
            x1: leftCapControl1XFactor,
            y1: lowerControlReflectivePoint + verticalControlReflectiveDistance,
            /// The second control point of the left endcap pulls its curve slightly less low but farther to the left
            x2: leftCapControl2XFactor,
            y2: upperControlReflectivePoint + verticalControlReflectiveDistance)
        )
    ]
    
    /// A Dictionary of two-point SegmentControllers, stored by their SquiggleName for readability, for a squiggle that
    /// points up at the left side.
    static var upLeftControlFactors: [FourPartSegmentName: SegmentController] = [
        .upper: (SegmentController.from(
            x1: center,
            y1: bottom,
            x2: center,
            y2: aboveTheTop)
        ),
        .right: (SegmentController.from(
            x1: rightCapControl2XFactor,
            y1: upperControlReflectivePoint + (verticalControlReflectiveDistance),
            x2: rightCapControl1XFactor,
            y2: lowerControlReflectivePoint + verticalControlReflectiveDistance)
        ),
        .lower: (SegmentController.from(
            x1: center,
            y1: top,
            x2: center,
            y2: belowTheBottom)
        ),
        .left: (SegmentController.from(
            x1: leftCapControl2XFactor,
            y1: lowerControlReflectivePoint - verticalControlReflectiveDistance,
            x2: leftCapControl1XFactor,
            y2: upperControlReflectivePoint - verticalControlReflectiveDistance)
        )
    ]
} // end SquiggleConstants

