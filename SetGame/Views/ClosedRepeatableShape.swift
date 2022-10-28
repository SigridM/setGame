//
//  ClosedRepeatableShape.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/24/22.
//

import SwiftUI

/// A ClosedRepeatableShape draws a given number of shapes, each shape drawn with straight lines among a set of points,
/// circling around the points from the last to the first to close the shape. The entire set of shapes is scaled to its enclosing rectangle.
protocol ClosedRepeatableShape: Shape {
    
    /// The total number of shapes to be drawn, stacked vertically, defaulting to one.
    var repetitions: Int {get set}
    
    /// The points that make up the endpoints of the shape, represented as fractions of a unit so they can be scaled to the
    /// enclosing rectangle
    var pointFactors: [CGPoint] {get}
    
    /// An opportunity for the implementer of this protocol to initialize any instance variables
    init()
    
}

extension ClosedRepeatableShape {
    
    /// Initialize the RepeatableShape to have any number (greater than or equal to 1) of repetitions of the shape, stacked vertically
    init(_ repetitions: Int) {
        self.init()
        guard repetitions > 0 else {
            self.repetitions = 1
            return
        }
        self.repetitions = repetitions
    }
    
    /// Default number of repetitions to one
    var repetitions: Int {
        return 1
    }
    
    /// Creates and returns an array of the CGPoints delimiting the segments of the repeatable shape, scaled to
    /// the given CGSize
    /// - Parameter size: a CGSize into which the shape should fit.
    /// - Returns: an Array of four CGPoints
    func pointsScaled(to size: CGSize) -> [CGPoint] {
        let scaling = CGAffineTransform(scaleX: size.width, y: size.height)
        return pointFactors.map{$0.applying(scaling)}
    }
    
    
    /// To conform to the Shape protocol, creates and returns the Path that draws the shape.
    /// - Parameter rect: a CGRect that circumscribes the diamond
    /// - Returns: a Path that draws the diamond
    func path(in rect: CGRect) -> Path {
        return shapes(in: rect)
    }
    
    /// Creates and returns a Path that draws a number of shapes, stacked vertically, the number of which is specified by
    /// the receiver's repetitions instance variable.
    /// - Parameter rect: a CGRect circumscribing all the diamonds
    /// - Returns: a Path that draws the diamonds
    private func shapes(in rect: CGRect) -> Path {
        var points = pointsScaled(to: rect.size)
        
        // to fit all the repetitions into the space, we must divide the space up, vertically,
        // by the number of repetitions
        let divisor = Double(repetitions)
        
        let scale = CGSize(width: 1.0, height: 1.0/divisor)
        points = points.map{$0.scaled(to: scale)}
        
        // once you have the scaled points, move them to the top of the CGRect
        points = points.map{$0.moved(by: rect.origin)}
        
        let shift = CGPoint(x: 0.0, y: rect.height/divisor) // how far down to shift each rep
        
        var path = Path()
        
        var iteration = 1
        
        repeat {
            addShapeTo(&path, using: points)
            points = points.map{$0.moved(by: shift)}
            iteration += 1
        } while iteration <= repetitions
        
        return path
    }
    
    /// Adds a single shape to the given path
    /// - Parameters:
    ///   - path: the Path that will be modified to include the new shape
    ///   - points: the end points delimiting the four lines of the shape
    private func addShapeTo(_ path: inout Path, using points: [CGPoint]) {
        path.move(to: points[0])
        
        for pointIndex in points.indices {
            path.addLine(to: points[(pointIndex + 1) % points.count])
        }
    }
    
    /// For debugging purposes, add a circles to the given path that show the point at the beginning of a line
    /// - Parameters:
    ///   - path: the Path that will be modified by adding a circle to it
    ///   - point: the CGPoint at the beginning of the line
    private func addCircle(to path: inout Path, using point: CGPoint) {
        let radius = 4.0
        
        // Move to and draw a larger circle at the beginning point
        path.move(to: point)
        path.addArc(center: point,
                    radius: radius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        
    }
    
    /// For debugging purposes, create and return a path that draws a circle for the end point of each line of each shape in the receiver:
    /// the point is the point at the beginning of a line. This is repeated for each shape in the receiver, scaled and shifted
    /// appropriately.
    /// - Parameters:
    ///   - rect: a CGRect circumscribing the entire shape
    ///   - originIndex: the index of the point starting the segment
    /// - Returns: a Path that draws all the circles
    private func dotsPath(in rect: CGRect, from originIndex: Int) -> Path {
        
        var point = pointsScaled(to: rect.size)[originIndex]
        let divisor = Double(repetitions)
        
        let scale = CGSize(width: 1.0, height: 1.0/divisor)
        point = point.scaled(to: scale)
        
        // once you have the scaled points, move them to the top of the CGRect
        point = point.moved(by: rect.origin)
        
        let shift = CGPoint(x: 0.0, y: rect.height/divisor)
        
        var path = Path()
        var iteration = 1
        
        repeat {
            addCircle(to: &path, using: point)
            point = point.moved(by: shift)
            iteration += 1
        } while iteration <= repetitions
        
        return path
    }
        
    /// For debugging purposes, creates and returns a ZStack of Views, each of which contains a path for a ClosedRepeatableShape of one of
    /// the given colors, where the path can show the beginning point that begins each of the shape's lines
    /// - Parameters:
    ///   - rect: the CGRect that circumscribes the entire shape
    ///   - colors: an Array of Colors, one for each of the  segments of the shape
    /// - Returns: a composite View of all of the shapes, with their dot paths, stacked on top of each other.
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

