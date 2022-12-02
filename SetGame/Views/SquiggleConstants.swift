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
    
    /// All points are the same distance from the left and right edges, counted from 0 clockwise from the upper left
    private static let xInset = 8.0
    private static let leftmostXFactor = xInset / defaultWidth
    private static let rightmostXFactor = (defaultWidth - xInset) / defaultWidth
    
    /// points 0 and 2 (counting from 0 at the upper left, moving clockwise around the squiggle) are in the vertical center
    private static let centerYFactor = 1.0 / 2.0
    
    /// points 1 and 3 (counting from 0 at the upper left, moving clockwise around the squiggle) are close to the top and bottom, respectively
    private static let outmostPointYInset = 4.0
    private static let highestPointYFactor = outmostPointYInset / defaultHeight
    private static let lowestPointYFactor = (defaultHeight - outmostPointYInset) / defaultHeight

    /// An Array of the four points delineating the four segments of a squiggle that points down on the left side. These are
    /// arrayed starting from the upper left of the squiggle and moving clockwise around the squiggle: left-center, right-high,
    /// right-center, left-low.
    static var downLeftPointFactors = [
        CGPoint(x: leftmostXFactor, y: centerYFactor),
        CGPoint(x: rightmostXFactor, y: highestPointYFactor),
        CGPoint(x: rightmostXFactor, y: centerYFactor),
        CGPoint(x: leftmostXFactor, y: lowestPointYFactor)
    ]
    
    /// An Array of the four points delineating the four segments of a squiggle that points up on the left side. These are
    /// arrayed starting from the upper left of the squiggle and moving clockwise around the squiggle: left-high, right-center,
    /// right-low, left-center.
    static var upLeftPointFactors = [
        CGPoint(x: leftmostXFactor, y: highestPointYFactor),
        CGPoint(x: rightmostXFactor, y: centerYFactor),
        CGPoint(x: rightmostXFactor, y: lowestPointYFactor),
        CGPoint(x: leftmostXFactor, y: centerYFactor)
    ]
    
    private static let centerX = 30.0
    private static let centerOffset = 2.0
    private static let rightOfCenterFactor = (centerX + centerOffset) / defaultWidth
    private static let leftOfCenterFactor = (centerX - centerOffset) / defaultWidth
    /// control points for the high hump of the upper curve, and the low dip of the lower
    /// curve, are equal distance away from the left and right edges, respectively
    private static let innerControlXInset = 32.0
    private static let upperControl1XFactor = innerControlXInset / defaultWidth
    private static let lowerControl1XFactor = (defaultWidth - innerControlXInset) / defaultWidth
    
    /// control points for the low dip of the upper curve, and the high hump of the lower
    /// curve, are equal distances away from the right and left edges, respectively
    private static let outerControlXInset = innerControlXInset - 4.0
    private static let upperControl2XFactor = (defaultWidth - outerControlXInset) / defaultWidth
    private static let lowerControl2XFactor = outerControlXInset / defaultWidth
    
    /// control points for the high hump of the upper curve, and the low dip of the lower
    /// curve, are equal distances above and below the top and bottom edges, respectively
    private static let outerControlYInset = -15.0
    private static let upperControl1YFactor = outerControlYInset / defaultHeight
    private static let lowerControl1YFactor = (defaultHeight - outerControlYInset) / defaultHeight
    
    /// control points for the low dip of the upper curve, and the high hump of the lower
    /// curve, are equal distances below and above the bottom and top edges, respectively
    private static let innerControlYInset = outerControlYInset + 15
    private static let upperControl2YFactor = (defaultHeight - innerControlYInset) / defaultHeight
    private static let lowerControl2YFactor = innerControlYInset / defaultHeight
    
    /// control points for the inner parts of the left and right endcaps are the same distance
    /// from the left and right edges, respectively
    private static let innerEndCapYInset = 2.0
    private static let leftCapControl1XFactor = innerEndCapYInset / defaultWidth
    private static let rightCapControl1XFactor = (defaultWidth - innerEndCapYInset) / defaultWidth
    
    /// control points for the outer parts of the right and left endcaps are the same distance
    /// outside the right and left edges, respectively
    private static let outerEndCapXInset = -1.0
    private static let rightCapControl2XFactor = (defaultWidth - outerEndCapXInset) / defaultWidth
    private static let leftCapControl2XFactor = outerEndCapXInset / defaultWidth
    
    /// control points for the highest and lowest parts of the right and left endcaps, respectively
    /// are the same distance above and below the top and bottom edges, respectively
    private static let fartherEndCapXInset = -1.0
    private static let rightCapControl1YFactor = fartherEndCapXInset / defaultHeight
    private static let leftCapControl1YFactor = (defaultHeight - fartherEndCapXInset) / defaultHeight
    
    /// control points for the closer parts of the right and left endcaps are the same distance
    /// inside the top and bottom edges, respectively
    private static let closerEndCapYInset = 0.5
    private static let rightCapControl2YFactor = closerEndCapYInset / defaultHeight
    private static let leftCapControl2YFactor = (defaultHeight - closerEndCapYInset) / defaultHeight
    
    /// A Dictionary of two-point SegmentControllers, stored by their SquiggleName for readability, for a squiggle that
    /// points down at the left side. The curves are drawn beginning from the upper left side, moving clockwise.
    ///
    /// The first control point of the upper curve pulls its dip down and to the right of center
    /// The second control point of the upper curve pulls its hump up and to the right of center
    ///
    /// The first control point of the right endcap pulls its curve down and far to the right
    /// The second control point of the right endcap pulls its curve slightly farther down but not as far to the right.
    ///
    /// The first (continuing to move clockwise) control point of the lower curve pulls its hump up and to the left of center
    /// The second control point of the lower curve pulls its dip down and to the left of center
    static var downLeftControlFactors: [FourPartSegmentName: SegmentController] = [
        .upper: (SegmentController.from(
            x1: rightOfCenterFactor,
            y1: upperControl1YFactor,
            x2: rightOfCenterFactor,
            y2: upperControl2YFactor)),
        .right: (SegmentController.from(
            x1: rightCapControl1XFactor,
            y1: rightCapControl1YFactor,
            x2: rightCapControl2XFactor,
            y2: rightCapControl2YFactor)),
        .lower: (SegmentController.from(
            x1: leftOfCenterFactor,
            y1: lowerControl1YFactor,
            x2: leftOfCenterFactor,
            y2: lowerControl2YFactor)),
        .left: (SegmentController.from(
            x1: leftCapControl1XFactor,
            y1: leftCapControl1YFactor,
            x2: leftCapControl2XFactor,
            y2: leftCapControl2YFactor))
    ]
    
    /// A Dictionary of two-point SegmentControllers, stored by their SquiggleName for readability, for a squiggle that
    /// points up at the left side.
    static var upLeftControlFactors: [FourPartSegmentName: SegmentController] = [
        .upper: (SegmentController.from(
            x1: upperControl1XFactor,
            y1: upperControl2YFactor,
            x2: upperControl2XFactor,
            y2: upperControl1YFactor)),
        .right: (SegmentController.from(
            x1: rightCapControl2XFactor,
            y1: leftCapControl2YFactor,
            x2: rightCapControl1XFactor,
            y2: leftCapControl1YFactor)),
        .lower: (SegmentController.from(
            x1: lowerControl2XFactor,
            y1: lowerControl2YFactor,
            x2: lowerControl1XFactor,
            y2: lowerControl1YFactor)),
        .left: (SegmentController.from(
            x1: leftCapControl2XFactor,
            y1: rightCapControl2YFactor,
            x2: leftCapControl1XFactor,
            y2: rightCapControl1YFactor))
    ]
} // end SquiggleConstants

