//
//  SquiggleShape.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 9/26/22.
//

import SwiftUI

/// A Shape that creates a path for a worm-like curve. By default, it draws a single squiggle, but can be configured to draw
/// any number of squiggles, stacked vertically, by initializing the shape with a number of repetitions
struct SquiggleShape: Shape {
    /// The total number of squiggles to be drawn, stacked vertically, defaulting to one.
    let repetitions: Int
    
    /// Initialize the SquiggleShape to have the default single squiggle
    init() {
        self.repetitions = 1
    }
    
    /// Initialize the SquiggleShape to have any number (greater than 1) of repetitions of the squiggle, stacked vertically
    /// - Parameter repetitions: the number of repetitions of the squiggle
    init(_ repetitions: Int) {
        guard repetitions > 0 else {
            self.repetitions = 1
            return
        }
        self.repetitions = repetitions
    }
    
    /// A struct to encapsulate the constants for the Squiggle drawing
    struct SquiggleConstants {
        /// Because the original squiggle was drawn in a 60x20 rectangle, all inset calculations are
        /// based proportionally on that original grid, as if it was a 1x1 square. The insets are
        /// later scaled by the dimensions of a circumscribing rectangle to fit that rectangle.
        private static let defaultWidth = 60.0
        private static let defaultHeight = 20.0
        
        /// points 0 and 2 are close to the left and right edges, respectively
        private static let outmostPointXInset = 1.0
        private static let point0XFactor = outmostPointXInset / defaultWidth
        private static let point2XFactor = (defaultWidth - outmostPointXInset) / defaultWidth
        
        /// points 1 and 3 are slightly farther from the right and left edges, respectively
        private static let secondPointXInset = 4.0
        private static let point1XFactor = (defaultWidth - secondPointXInset) / defaultWidth
        private static let point3XFactor = secondPointXInset / defaultWidth
        
        /// points 1 and 3 are close to the top and bottom, respectively
        private static let outmostPointYInset = 2.0
        private static let point1YFactor = outmostPointYInset / defaultHeight
        private static let point3YFactor = (defaultHeight - outmostPointYInset) / defaultHeight
        
        /// points 0 and 2 are slightly farther from the bottom and top, respectively
        private static let secondPointYInset = 4.0
        private static let point0YFactor = (defaultHeight - secondPointYInset) / defaultHeight
        private static let point2YFactor = secondPointYInset / defaultHeight
        
        /// An Array of the four points delineating the four segments of the squiggle
        static let pointFactors = [
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
        private static let outerControlXInset = 31.0
        private static let upperControl2XFactor = (defaultWidth - outerControlXInset) / defaultWidth
        private static let lowerControl2XFactor = outerControlXInset / defaultWidth
        
        /// control points for the high hump of the upper curve, and the low dip of the lower
        /// curve, are equal distances above and below the top and bottom edges, respectively
        private static let outerControlYInset = -29.0
        private static let upperControl1YFactor = outerControlYInset / defaultHeight
        private static let lowerControl1YFactor = (defaultHeight - outerControlYInset) / defaultHeight
        
        /// control points for the low dip of the upper curve, and the high hump of the lower
        /// curve, are equal distances below and above the bottom and top edges, respectively
        private static let innerControlYInset = -24.0
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
        private static let fartherEndCapYInset = -1.0
        private static let rightCapControl1YFactor = fartherEndCapYInset / defaultHeight
        private static let leftCapControl1YFactor = (defaultHeight - fartherEndCapYInset) / defaultHeight
        
        /// control points for the closer parts of the right and left endcaps are the same distance
        /// inside the top and bottom edges, respectively
        private static let closerEndCapYInset = 0.5
        private static let rightCapControl2YFactor = closerEndCapYInset / defaultHeight
        private static let leftCapControl2YFactor = (defaultHeight - closerEndCapYInset) / defaultHeight
        
        /// A Dictionary of two-point SegmentControllers, stored by their SquiggleName for readability
        static let controlFactors: [SegmentName: SegmentController] = [
            .upper: (SegmentController.from(x1: upperControl1XFactor,
                                          y1: upperControl1YFactor,
                                          x2: upperControl2XFactor,
                                          y2: upperControl2YFactor)),
            .right: (SegmentController.from(x1: rightCapControl1XFactor,
                                          y1: rightCapControl1YFactor,
                                          x2: rightCapControl2XFactor,
                                          y2: rightCapControl2YFactor)),
            .lower: (SegmentController.from(x1: lowerControl1XFactor,
                                          y1: lowerControl1YFactor,
                                          x2: lowerControl2XFactor,
                                          y2: lowerControl2YFactor)),
            .left: (SegmentController.from(x1: leftCapControl1XFactor,
                                         y1: leftCapControl1YFactor,
                                         x2: leftCapControl2XFactor,
                                         y2: leftCapControl2YFactor))
        ]
        
        /// For debugging, the radius of the circle that shows where a point is that defines the end of a segment
        static let defaultPointRadius = 4.0
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
    
    /// Creates and returns an array of the four CGPoints delimiting the four segments of the squiggle, scaled to
    /// the given CGSize
    /// - Parameter size: a CGSize into which the squiggle should fit.
    /// - Returns: an Array of four CGPoints
    private func pointsScaled(to size: CGSize) -> [CGPoint] {
        let scaling = CGAffineTransform(scaleX: size.width, y: size.height)
        return SquiggleConstants.pointFactors.map{$0.applying(scaling)}
    }
    
    /// Creates and returns a Dictionary of SegmentControllers, each of which controls some aspect
    /// of a curved segment of the squiggle. Each SegmentController contains the first and second control points
    /// for its segment. The four segments are "upper," "right," "lower," and "left." The points are all scaled
    /// to fit inside the given CGSize.
    /// - Parameter size: a CGSize into which the squiggle should fit.
    /// - Returns: a Dictionary with four SegmentControllers, keyed by SegmentName, each of whose points have been scaled
    /// to the given size.
    private func controlPointsScaled(to size: CGSize) -> [SegmentName: SegmentController] {
        return SquiggleConstants.controlFactors.mapValues{$0.scaled(to: size)}
    }
    
    /// Adds a single squiggle to the given path
    /// - Parameters:
    ///   - path: the Path that will be modified to include the new squiggle
    ///   - points: the end points delimiting the four segments of the squiggle
    ///   - controls: the four SegmentControllers that contain the control points of the curve of each segment
    private func addSquiggleTo(_ path: inout Path,
                               using points: [CGPoint],
                               and controls: [SegmentName: SegmentController]) {
        path.move(to: points[0])
        
        for segment in SegmentName.allCases {
            let segmentNum = segment.rawValue
            path.addCurve(to: points[segmentNum],
                          control1: controls[segment]!.control1,
                          control2: controls[segment]!.control2)
        }
    }

    /// Creates and returns a Path that draws a number of squiggles, stacked vertically, the number of which is specified by
    /// the receiver's repetitions instance variable.
    /// Note that for squiggles to look the same, no matter the number you draw, the rectangles should be proportional to the largest
    /// number of squiggles you draw. E.g., if you are drawing a total of four squiggles, your single squiggle rect should be one
    /// fourth the height of the quadruple-squiggle rect.
    /// - Parameter rect: a CGRect circumscribing all the squiggles
    /// - Returns: a Path that draws the squiggles
    private func squiggles(in rect: CGRect) -> Path {
        var points = pointsScaled(to: rect.size)
        var controlPoints = controlPointsScaled(to: rect.size)
        
        // to fit all the repetitions into the space, we must divide the space up, vertically,
        // by the number of repetitions
        let divisor = Double(repetitions)
        
        let scale = CGSize(width: 1.0, height: 1.0/divisor)
        points = points.map{$0.scaled(to: scale)}
        controlPoints = controlPoints.mapValues{$0.scaled(to: scale)}
        
        // once you have the scaled points, move them to the top of the CGRect
        points = points.map{$0.moved(by: rect.origin)}
        controlPoints = controlPoints.mapValues{$0.moved(by: rect.origin)}
        
        let shift = CGPoint(x: 0.0, y: rect.height/divisor) // how far down to shift each rep
        
        var path = Path()
        
        var iteration = 1
        
        repeat {
            addSquiggleTo(&path, using: points, and: controlPoints)
            points = points.map{$0.moved(by: shift)}
            controlPoints = controlPoints.mapValues{$0.moved(by: shift)}
            iteration += 1
        } while iteration <= repetitions
        
        return path
    }
    
    /// For debugging purposes, create and return a path that draws three circles for each segment of each squiggle in the receiver:
    /// the three points are the point at the beginning of a segment, and the two control points controlling the curve of that segment
    /// that begins at the point and goes to the next point. This is repeated for each squiggle in the receiver, scaled and shifted
    /// appropriately.
    /// - Parameters:
    ///   - rect: a CGRect circumscribing the entire SquiggleShape
    ///   - originIndex: the index of the point starting the segment
    /// - Returns: a Path that draws all the circles
    private func dotsPath(in rect: CGRect, from originIndex: Int) -> Path {
        
        let destinationIndex = (originIndex + 1) % SquiggleConstants.pointFactors.count
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
        let radius = SquiggleConstants.defaultPointRadius
        
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
    
    /// For debugging purposes, creates and returns a ZStack of Views, each of which contains a path for a SquiggleShape of one of
    /// the given colors, where the path can show the points and control points that make up the squiggle's curves
    /// - Parameters:
    ///   - rect: the CGRect that circumscribes the entire SquiggleShape
    ///   - colors: an Array of Colors, one for each of the four segments of the Squiggle
    /// - Returns: a composite View of all of the SquiggleShapes, with their dot paths, stacked on top of each other.
    @ViewBuilder
    func debugViews(in rect: CGRect, with colors: [Color]) -> some View {
        ZStack {
            ForEach(0..<4) { index in
                SquiggleShape(repetitions)
                    .dotsPath(in: rect, from: index)
                    .foregroundColor(colors[index])
                    .opacity(0.75)
            }
        }
    }
    
    /// To conform to the Shape protocol, creates and returns the Path that draws the shape.
    /// - Parameter rect: a CGRect that circumscribes the squiggle
    /// - Returns: a Path that draws the squiggle
    func path(in rect: CGRect) -> Path {
        return squiggles(in: rect)
    }
}

/// Tests the SquiggleShape by drawing each of three sets of squiggles: a SquiggleShape with one squiggle; a SquiggleShape with
/// two squiggles, and a SquiggleShape with three squiggles. Because all squiggles should be the same size, regardless of the number,
/// the first is drawn in a rectangle one third the height of the last, and the second in a rectangle 2/3 the height of the last, with each one
/// centererd vertically.  Additional rects and dots are drawn for debugging purposes, if debuggingn is true
struct SquiggleView: View {
    let debugging = false
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
//            Canvas { context, size in
//                let rect = CGRect(origin: .zero, size: size)
//                let path = SquiggleShape(3).path(in: rect)
//                let gradient = Gradient(colors: [.green, .blue])
//                let from = rect.origin
//                let to = rect.corner
//
//                context.stroke(path, with: .color(.blue), lineWidth: 3)
// //                context.fill(path, with: .linearGradient(gradient, startPoint: from, endPoint: to))
//                context.fill(path, with: GraphicsContext.Shading.color(.red))
//            }.shadow(radius: 5.0)
        }
        .padding()
    }
}

struct SquiggleShape_Previews: PreviewProvider {
    static var previews: some View {
        SquiggleView()
    }
}
