//
//  SquiggleShape.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 9/26/22.
//

import SwiftUI

/// A Shape that creates a path for a worm-like curve. By default, it draws a single squiggle, but can be configured to draw
/// any number of squiggles, stacked vertically, by initializing the shape with a number of repetitions
struct SquiggleShape: CurvedClosedRepeatableShape {
    
    /// The total number of squiggles to be drawn, stacked vertically, defaulting to one.
    var repetitions = 1
    let pointFactors = SquiggleConstants.pointFactors
    let controlFactors = SquiggleConstants.controlFactors
    typealias SegmentKey = FourPartSegmentName
    
    /// A struct to encapsulate the constants for the Squiggle drawing
    struct SquiggleConstants {
        /// Because the original squiggle was drawn in a 60x20 rectangle, all inset calculations are
        /// based proportionally on that original grid, as if it was a 1x1 square. The insets are
        /// later scaled by the dimensions of a circumscribing rectangle to fit that rectangle.
        private static let defaultWidth = 60.0
        private static let defaultHeight = 20.0
        
        /// points 0 and 2 are close to the left and right edges, respectively
        private static let outmostPointXInset = 8.0
        private static let point0XFactor = outmostPointXInset / defaultWidth
        private static let point2XFactor = (defaultWidth - outmostPointXInset) / defaultWidth
        
        /// points 1 and 3 are slightly farther from the right and left edges, respectively
        private static let secondPointXInset = 8.0
        private static let point1XFactor = (defaultWidth - secondPointXInset) / defaultWidth
        private static let point3XFactor = secondPointXInset / defaultWidth
        
        /// points 1 and 3 are close to the top and bottom, respectively
        private static let outmostPointYInset = 4.0
        private static let point1YFactor = outmostPointYInset / defaultHeight
        private static let point3YFactor = (defaultHeight - outmostPointYInset) / defaultHeight
        
        /// points 0 and 2 are slightly farther from the bottom and top, respectively
        private static let secondPointYInset = 10.0
        private static let point0YFactor = (defaultHeight - secondPointYInset) / defaultHeight
        private static let point2YFactor = secondPointYInset / defaultHeight
        
        /// An Array of the four points delineating the four segments of the squiggle
        static var pointFactors = [
            CGPoint(x: point0XFactor, y: point0YFactor),
            CGPoint(x: point1XFactor, y: point1YFactor),
            CGPoint(x: point2XFactor, y: point2YFactor),
            CGPoint(x: point3XFactor, y: point3YFactor)
        ]
        
        /// control points for the high hump of the upper curve, and the low dip of the lower
        /// curve, are equal distance away from the left and right edges, respectively
        private static let innerControlXInset = 33.0
        private static let upperControl1XFactor = innerControlXInset / defaultWidth
        private static let lowerControl1XFactor = (defaultWidth - innerControlXInset) / defaultWidth
        
        /// control points for the low dip of the upper curve, and the high hump of the lower
        /// curve, are equal distances away from the right and left edges, respectively
        private static let outerControlXInset = innerControlXInset - 2.0
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
        
        /// A Dictionary of two-point SegmentControllers, stored by their SquiggleName for readability
        static var controlFactors: [FourPartSegmentName: SegmentController] = [
            .upper: (SegmentController.from(
                x1: upperControl1XFactor,
                y1: upperControl1YFactor,
                x2: upperControl2XFactor,
                y2: upperControl2YFactor)),
            .right: (SegmentController.from(
                x1: rightCapControl1XFactor,
                y1: rightCapControl1YFactor,
                x2: rightCapControl2XFactor,
                y2: rightCapControl2YFactor)),
            .lower: (SegmentController.from(
                x1: lowerControl1XFactor,
                y1: lowerControl1YFactor,
                x2: lowerControl2XFactor,
                y2: lowerControl2YFactor)),
            .left: (SegmentController.from(
                x1: leftCapControl1XFactor,
                y1: leftCapControl1YFactor,
                x2: leftCapControl2XFactor,
                y2: leftCapControl2YFactor))
        ]
    } // end SquiggleConstants
} // end SquiggleShape

/// Tests the SquiggleShape by drawing each of three sets of squiggles: a SquiggleShape with one squiggle; a SquiggleShape with
/// two squiggles, and a SquiggleShape with three squiggles. Because all squiggles should be the same size, regardless of the number,
/// the first is drawn in a rectangle one third the height of the last, and the second in a rectangle 2/3 the height of the last, with each one
/// centererd vertically.  Additional rects and dots are drawn for debugging purposes, if debuggingn is true
struct SquiggleView: View {
    let debugging = true
    let color: Color = .red
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    let wholeRect = CGRect(x:0,
                                           y: 0,
                                           width: geometry.size.width,
                                           height: geometry.size.height)
                    
                    // so that the squiggles in all three rects remain the same size,
                    // make this one, with only one squiggle, one third the height of the
                    // whole rect, and center it one third of the way down the rect
                    let squiggleRect = CGRect(x:0,
                                              y: 0 + wholeRect.height/3,
                                              width: wholeRect.width,
                                              height: wholeRect.height/3)
                    
                    SquiggleShape()
                        .path(in: squiggleRect)
                        .strokedPath(StrokeStyle(lineWidth: 3.0))
                        .foregroundColor(color)
                    
                    if debugging {
                        Rectangle()
                            .path(in: wholeRect)
                            .strokedPath(StrokeStyle(lineWidth: 3.0))
                        Rectangle()
                            .path(in: squiggleRect)
                            .opacity(0.1)
                        SquiggleShape()
                            .debugViews(in: squiggleRect, with: [.red, .purple, .green, .blue])
                    }
                    Spacer()
                }
            }
            GeometryReader {geometry in
                ZStack {
                    
                    let wholeRect = CGRect(x:0,
                                           y: 0,
                                           width: geometry.size.width,
                                           height: geometry.size.height)
                    
                    // so that the squiggles in all three rects remain the same size,
                    // make this one, with only two squiggles, two thirds the height of the
                    // whole rect, and center it one sixth of the way down the rect
                    let squiggleRect = CGRect(x:0,
                                              y: 0 + wholeRect.height/6,
                                              width: wholeRect.width,
                                              height: wholeRect.height*2/3)
                    SquiggleShape(2)
                        .path(in: squiggleRect)
                        .foregroundColor(color)
                    
                    if debugging {
                        Rectangle()
                            .path(in: wholeRect)
                            .strokedPath(StrokeStyle(lineWidth: 3.0))
                        Rectangle()
                            .path(in: squiggleRect)
                            .opacity(0.1)
                        SquiggleShape(2)
                            .debugViews(in: squiggleRect, with: [.orange, .purple, .teal, .cyan])
                    }
                    Spacer()
                }
            }
            GeometryReader {geometry3 in
                ZStack {
                    let squiggleRect = CGRect(x:0,
                                              y: 0,
                                              width: geometry3.size.width,
                                              height: geometry3.size.height)
                    let image = Image(systemName: "circle.grid.3x3")
                    SquiggleShape(3)
                        .path(in: squiggleRect)
                        .foregroundColor(color)
                        .opacity(0.65)
                    SquiggleShape(3)
                        .path(in: squiggleRect)
                        .foregroundStyle(.image(image))
                        .opacity(0.55)
                    
                    if debugging {
                        Rectangle()
                            .path(in: squiggleRect)
                            .strokedPath(StrokeStyle(lineWidth: 3.0))
                        Rectangle()
                            .path(in: squiggleRect)
                            .opacity(0.1)
                        SquiggleShape(3)
                            .debugViews(in: squiggleRect, with: [.red, .purple, .green, .blue])
                            .opacity(0.75)
                    }
                    Spacer()
                }
            }
        } // end VStack

        .padding()
    } // end body
} // end SquiggleView

struct SquiggleShape_Previews: PreviewProvider {
    static var previews: some View {
        SquiggleView()
    }
}
