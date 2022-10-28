//
//  CurvedClosedRepeatableShape.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/27/22.
//

import SwiftUI

/// A CurvedClosedRepeatableShape draws a given number of shapes, each shape drawn with bezier curves among a set of points,
/// circling around the points from the last to the first to close the shape. The entire set of shapes is scaled to its enclosing rectangle.
protocol CurvedClosedRepeatableShape: ClosedRepeatableShape {
    
    /// For identifying each segment by both name (for readability) and number (for iterating around the shape's segments), require
    /// a type that is, essentially, a CaseIterable enum of the names with the numbers as raw values for a key into the controlFactors
    /// Dictionary
    associatedtype SegmentKey: RawRepresentable, Hashable, CaseIterable
    
    /// A Dictionary of SegmentControllers, each stored by a case of an enum. ach SegmentController contains the first and second
    /// control points that define the curve for its segment.
    var controlFactors: [SegmentKey: SegmentController] {get}
    
}

extension CurvedClosedRepeatableShape {
    
    /// Creates and returns a Dictionary of SegmentControllers, each of which controls some aspect
    /// of a curved segment of the oval. Each SegmentController contains the first and second control points
    /// that define the curve for its segment. The points are all scaled to fit inside the given CGSize.
    /// - Parameter size: a CGSize into which the oval should fit.
    /// - Returns: a Dictionary with four SegmentControllers, keyed by SegmentKey, each of whose points have been scaled
    /// to the given size.
    func controlPointsScaled(to size: CGSize) -> [SegmentKey: SegmentController] {
        return controlFactors.mapValues{$0.scaled(to: size)}
    }
    
    /// Adds a single shape to the given path
    /// - Parameters:
    ///   - path: the Path that will be modified to include the new shape
    ///   - points: the end points delimiting the four of the shape
    ///   - controls: the SegmentControllers that contain the control points of the curve of each segment
    func addShapeTo(_ path: inout Path,
                    using points: [CGPoint],
                    and controls: [SegmentKey: SegmentController]) {
        path.move(to: points[0])
        
        for segment in SegmentKey.allCases {
            let segmentNum = segment.rawValue as! Int
            path.addCurve(to: points[segmentNum],
                          control1: controls[segment]!.control1,
                          control2: controls[segment]!.control2)
        }
    }
    
    /// Creates and returns a Path that draws a number of shapes, stacked vertically, the number of which is specified by
    /// the receiver's repetitions instance variable.
    /// Note that for shapes to look the same, no matter the number you draw, the rectangles should be proportional to the largest
    /// number of shapes you draw. E.g., if you are drawing a total of four shapes, your single shape rect should be one
    /// fourth the height of the quadruple-shape rect.
    /// - Parameter rect: a CGRect circumscribing all the shapes
    /// - Returns: a Path that draws the shapes
    func shapes(in rect: CGRect) -> Path {
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
            addShapeTo(&path, using: points, and: controlPoints)
            points = points.map{$0.moved(by: shift)}
            controlPoints = controlPoints.mapValues{$0.moved(by: shift)}
            iteration += 1
        } while iteration <= repetitions
        
        return path
    }
    
    /// To conform to the Shape protocol, creates and returns the Path that draws the shape.
    /// - Parameter rect: a CGRect that circumscribes the diamond
    /// - Returns: a Path that draws the diamond
    func path(in rect: CGRect) -> Path {
        return shapes(in: rect)
    }
    
    
    /// For debugging purposes, create and return a path that draws three circles for each segment of each shape in the receiver:
    /// the three points are the point at the beginning of a segment, and the two control points controlling the curve of that segment
    /// that begins at the point and goes to the next point. This is repeated for each oval in the receiver, scaled and shifted
    /// appropriately.
    /// - Parameters:
    ///   - rect: a CGRect circumscribing the entire shape
    ///   - originIndex: the index of the point starting the segment
    /// - Returns: a Path that draws all the circles
    private func dotsPath(in rect: CGRect, from originIndex: Int) -> Path {
        
        let destinationIndex = (originIndex + 1) % pointFactors.count
        let segment = SegmentKey(rawValue: destinationIndex as! Self.SegmentKey.RawValue)!
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
            addDots(to: &path, using: point, and: controlPoints[segment]!)
            point = point.moved(by: shift)
            controlPoints = controlPoints.mapValues{$0.moved(by: shift)}
            iteration += 1
        } while iteration <= repetitions
        
        return path
    }
    
    /// For debugging purposes, add the three dots to the given path that show the point at the beginning of a segment as well
    /// as the two control points for that segment
    /// - Parameters:
    ///   - path: the Path that will be modified by adding dots (closed circles) to it
    ///   - point: the CGPoint at the beginning of the segment
    ///   - controller: the SegmentController that contains the control points for the segment
    private func addDots(to path: inout Path, using point: CGPoint, and controller: SegmentController) {
        let radius = 4.0
        
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
            ForEach(0..<colors.count) { index in
                Self(repetitions)
                    .dotsPath(in: rect, from: index)
                    .foregroundColor(colors[index])
                    .opacity(0.75)
            }
        }
    }
}
