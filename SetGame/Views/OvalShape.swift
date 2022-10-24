//
//  OvalShape.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 9/26/22.
//

import SwiftUI

/// A Shape that creates a path for a worm-like curve. By default, it draws a single oval, but can be configured to draw
/// any number of ovals, stacked vertically, by initializing the shape with a number of repetitions
struct OvalShape: CurvedRepeatableShape {
    var pointConstants: RepeatableShapeConstants.Type
    
    var curveConstants: CurvedRepeatableShapeConstants.Type
    
    var repetitions: Int
    
    /// Initialize the OvalShape to have the default single oval
    init() {
        repetitions = 1
        pointConstants = OvalConstants.self
        curveConstants = OvalConstants.self
    }
    /// A struct to encapsulate the constants for the Oval drawing
    struct OvalConstants: CurvedRepeatableShapeConstants, RepeatableShapeConstants {
        
        /// Because the original oval was drawn in a 60x20 rectangle, all inset calculations are
        /// based proportionally on that original grid, as if it was a 1x1 square. The insets are
        /// later scaled by the dimensions of a circumscribing rectangle to fit that rectangle.
        private static let defaultWidth = 60.0
        private static let defaultHeight = 20.0
        
        /// points 0 and 3 are inset from the left edge, and points 1 and 2 are inset from the right edge; all by the same amount
        private static let pointXInset = 9.0
        private static let point0XFactor = pointXInset / defaultWidth
        private static let point1XFactor = (defaultWidth - pointXInset) / defaultWidth
        private static let point2XFactor = (defaultWidth - pointXInset) / defaultWidth
        private static let point3XFactor = pointXInset / defaultWidth
        
        /// points 0 and 1 are close to the top edge, and points 2 and 3 are close to the bottom edge; all by the same amount
        private static let pointYInset = 3.5
        private static let point0YFactor = pointYInset / defaultHeight
        private static let point1YFactor = pointYInset / defaultHeight
        private static let point2YFactor = (defaultHeight - pointYInset) / defaultHeight
        private static let point3YFactor = (defaultHeight - pointYInset) / defaultHeight
        
        /// An Array of the four points delineating the four segments of the oval
        static var pointFactors = [
            CGPoint(x: point0XFactor, y: point0YFactor),
            CGPoint(x: point1XFactor, y: point1YFactor),
            CGPoint(x: point2XFactor, y: point2YFactor),
            CGPoint(x: point3XFactor, y: point3YFactor)
        ]
        
        /// the first (moving clockwise) control point for the upper curve, and the second (moving clockwise) control point for the
        /// lower curve, are the same distance from the left edge; the second control point for the upper curve and the first
        /// control point for the lower curve are an equal distance away from the right edge.
        private static let controlXInset = 20.0
        private static let upperControl1XFactor = controlXInset / defaultWidth
        private static let upperControl2XFactor = (defaultWidth - controlXInset) / defaultWidth
        private static let lowerControl1XFactor = (defaultWidth - controlXInset) / defaultWidth
        private static let lowerControl2XFactor = controlXInset / defaultWidth
        
        /// both control points for the upper curve are on the top edge, and both control points for the lower curve are on the
        /// bottom edge.
        private static let controlYInset = 0.0
        private static let upperControl1YFactor = controlYInset / defaultHeight
        private static let upperControl2YFactor = controlYInset / defaultHeight
        private static let lowerControl1YFactor = (defaultHeight - controlYInset) / defaultHeight
        private static let lowerControl2YFactor = (defaultHeight - controlYInset) / defaultHeight
        
        /// both control points for the left endcap are slightly outside the left edge, and both control points for the right endcap
        /// are slightly outside the right edge; all by the same amount
        private static let endCapXInset = -1.5
        private static let leftCapControl1XFactor = endCapXInset / defaultWidth
        private static let leftCapControl2XFactor = endCapXInset / defaultWidth
        private static let rightCapControl1XFactor = (defaultWidth - endCapXInset) / defaultWidth
        private static let rightCapControl2XFactor = (defaultWidth - endCapXInset) / defaultWidth
        
        /// the first (moving clockwise) control point for the right endcap, and the second (moving clockwise) control point for the
        /// left endcap, are the same distance from the top edge; the second control point for the right endcap and the first
        /// control point for the left endcap are an equal distance away from the bottom edge.
        private static let endCapYInset = 7.0
        private static let rightCapControl1YFactor = endCapYInset / defaultHeight
        private static let rightCapControl2YFactor = (defaultHeight - endCapYInset) / defaultHeight
        private static let leftCapControl1YFactor = (defaultHeight - endCapYInset) / defaultHeight
        private static let leftCapControl2YFactor = endCapYInset / defaultHeight
        
        /// A Dictionary of two-point SegmentControllers, stored by their OvalName for readability
        static var controlFactors = [
            SegmentName.upper: (SegmentController.from(x1: upperControl1XFactor,
                                            y1: upperControl1YFactor,
                                            x2: upperControl2XFactor,
                                            y2: upperControl2YFactor)),
            SegmentName.right: (SegmentController.from(x1: rightCapControl1XFactor,
                                            y1: rightCapControl1YFactor,
                                            x2: rightCapControl2XFactor,
                                            y2: rightCapControl2YFactor)),
            SegmentName.lower: (SegmentController.from(x1: lowerControl1XFactor,
                                            y1: lowerControl1YFactor,
                                            x2: lowerControl2XFactor,
                                            y2: lowerControl2YFactor)),
            SegmentName.left: (SegmentController.from(x1: leftCapControl1XFactor,
                                           y1: leftCapControl1YFactor,
                                           x2: leftCapControl2XFactor,
                                           y2: leftCapControl2YFactor))
        ]

        
        /// For debugging, the radius of the circle that shows where a point is that defines the end of a segment
        static let defaultPointRadius = 4.0
    }

    
    /// For debugging purposes, create and return a path that draws three circles for each segment of each oval in the receiver:
    /// the three points are the point at the beginning of a segment, and the two control points controlling the curve of that segment
    /// that begins at the point and goes to the next point. This is repeated for each oval in the receiver, scaled and shifted
    /// appropriately.
    /// - Parameters:
    ///   - rect: a CGRect circumscribing the entire OvalShape
    ///   - originIndex: the index of the point starting the segment
    /// - Returns: a Path that draws all the circles
    private func dotsPath(in rect: CGRect, from originIndex: Int) -> Path {
        
        let destinationIndex = (originIndex + 1) % OvalConstants.pointFactors.count
        let segment = SegmentName(rawValue: destinationIndex)!
        var point = pointsScaled(to: rect.size)[originIndex]
        var controlPoints = controlPointsScaled(to: rect.size)
        let divisor = Double(repetitions)
        
        let scale = CGSize(width: 1.0, height: 1.0/divisor)
        point = point.scaled(to: scale)
        controlPoints = controlPoints.mapValues{$0.scaled(to: scale)}
        
        // once you have the scaled points, move them to the top of the CGRect
        point = point.moved(by: rect.origin)
        controlPoints = controlPoints.mapValues{$0.moved(by: rect.origin)}
        
        let shift = CGPoint(x: 0.0, y: rect.height/divisor)

        var path = Path()
        var iteration = 1

        repeat {
            addCircles(to: &path, using: point, and: controlPoints[segment]!)
            point = point.moved(by: shift)
            controlPoints = controlPoints.mapValues{$0.moved(by: shift)}
            iteration += 1
        } while iteration <= repetitions
        

        
        return path
    }
    
    /// For debugging purposes, add the three circles to the given path that show the point at the beginning of a segment as well
    /// as the two control points for that segment
    /// - Parameters:
    ///   - path: the Path that will be modified by adding circles to it
    ///   - point: the CGPoint at the beginning of the segment
    ///   - controller: the SegmentController that contains the control points for the segment
    private func addCircles(to path: inout Path, using point: CGPoint, and controller: SegmentController) {
        let radius = OvalConstants.defaultPointRadius
        
        // Move to and draw a larger circle at the beginning point
        path.move(to: point)
        path.addArc(center: point,
                    radius: radius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        
        // Move to and draw a smaller circle at the first control point
        path.move(to: controller.control1)
        path.addArc(center: controller.control1,
                    radius: radius/2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        
        // Move to and draw another small circle at the second control point
        path.move(to: controller.control2)
        path.addArc(center: controller.control2,
                    radius: radius / 2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
    }
    
    /// For debugging purposes, creates and returns a ZStack of Views, each of which contains a path for a OvalShape of one of
    /// the given colors, where the path can show the points and control points that make up the oval's curves
    /// - Parameters:
    ///   - rect: the CGRect that circumscribes the entire OvalShape
    ///   - colors: an Array of Colors, one for each of the four segments of the Oval
    /// - Returns: a composite View of all of the OvalShapes, with their dot paths, stacked on top of each other.
    @ViewBuilder
    func debugViews(in rect: CGRect, with colors: [Color]) -> some View {
        ZStack {
            ForEach(0..<4) { index in
                OvalShape(repetitions)
                    .dotsPath(in: rect, from: index)
                    .foregroundColor(colors[index])
                    .opacity(0.75)
            }
        }
    }

}

/// Tests the OvalShape by drawing each of three sets of ovals: a OvalShape with one oval; a OvalShape with
/// two ovals, and a OvalShape with three ovals. Because all ovals should be the same size, regardless of the number,
/// the first is drawn in a rectangle one third the height of the last, and the second in a rectangle 2/3 the height of the last, with each one
/// centererd vertically.  Additional rects and dots are drawn for debugging purposes, if debuggingn is true
struct OvalView: View {
    let debugging = false
    let color: Color = .green
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    let wholeRect = CGRect(x:0,
                                       y: 0,
                                       width: geometry.size.width,
                                       height: geometry.size.height)
                    
                    // so that the ovals in all three rects remain the same size,
                    // make this one, with only one oval, one third the height of the
                    // whole rect, and center it one third of the way down the rect
                    let ovalRect = CGRect(x:0,
                                      y: 0 + wholeRect.height/3,
                                      width: wholeRect.width,
                                      height: wholeRect.height/3)

                    OvalShape()
                        .path(in: ovalRect)
                        .strokedPath(StrokeStyle(lineWidth: 3.0))
                        .foregroundColor(color)
                    
                    if debugging {
                        Rectangle()
                            .path(in: wholeRect)
                            .strokedPath(StrokeStyle(lineWidth: 3.0))
                        Rectangle()
                            .path(in: ovalRect)
                            .opacity(0.1)
                        OvalShape()
                            .debugViews(in: ovalRect, with: [.red, .purple, .green, .blue])
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

                    // so that the ovals in all three rects remain the same size,
                    // make this one, with only two ovals, two thirds the height of the
                    // whole rect, and center it one sixth of the way down the rect
                    let ovalRect = CGRect(x:0,
                                       y: 0 + wholeRect.height/6,
                                       width: wholeRect.width,
                                       height: wholeRect.height*2/3)
                    OvalShape(2)
                        .path(in: ovalRect)
                        .foregroundColor(color)

                    if debugging {
                        Rectangle()
                            .path(in: wholeRect)
                            .strokedPath(StrokeStyle(lineWidth: 3.0))
                        Rectangle()
                            .path(in: ovalRect)
                            .opacity(0.1)
                        OvalShape(2)
                            .debugViews(in: ovalRect, with: [.orange, .purple, .teal, .cyan])
                    }
                    Spacer()
                }
            }
            GeometryReader {geometry3 in
                ZStack {
                    let ovalRect = CGRect(x:0,
                                      y: 0,
                                      width: geometry3.size.width,
                                      height: geometry3.size.height)
                    let image = Image(systemName: "circle.grid.3x3")
                    OvalShape(3)
                        .path(in: ovalRect)
                        .foregroundColor(color)
                        .opacity(0.65)
                    OvalShape(3)
                        .path(in: ovalRect)
                        .foregroundStyle(.image(image))
                        .opacity(0.55)

                    if debugging {
                        Rectangle()
                            .path(in: ovalRect)
                            .strokedPath(StrokeStyle(lineWidth: 3.0))
                        Rectangle()
                            .path(in: ovalRect)
                            .opacity(0.1)
                        OvalShape(3)
                            .debugViews(in: ovalRect, with: [.red, .purple, .green, .blue])
                        .opacity(0.75)
                    }
                    Spacer()
                }
            }
        }
        .padding()
    }
}

struct OvalShape_Previews: PreviewProvider {
    static var previews: some View {
        OvalView()
    }
}
