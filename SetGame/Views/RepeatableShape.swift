//
//  RepeatableShape.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/24/22.
//

import SwiftUI

protocol RepeatableShape: Shape {
    
    /// The total number of shapes to be drawn, stacked vertically, defaulting to one.
    var repetitions: Int {get set}
    var pointConstants: RepeatableShapeConstants.Type {get}
    
    init()
}

extension RepeatableShape {
    
    /// Initialize the RepeatableShape to have any number (greater than 1) of repetitions of the shape, stacked vertically
    init(_ repetitions: Int) {
        self.init()
        self.repetitions = 1
        guard repetitions > 0 else {
            return
        }
        self.repetitions = repetitions
    }
    
    /// Creates and returns an array of the CGPoints delimiting the segments of the repeatable shape, scaled to
    /// the given CGSize
    /// - Parameter size: a CGSize into which the shape should fit.
    /// - Returns: an Array of four CGPoints
    func pointsScaled(to size: CGSize) -> [CGPoint] {
        let scaling = CGAffineTransform(scaleX: size.width, y: size.height)
        return pointConstants.pointFactors.map{$0.applying(scaling)}
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
}

protocol CurvedRepeatableShape: RepeatableShape {
    
    /// The total number of shapes to be drawn, stacked vertically, defaulting to one.
    var repetitions: Int {get set}
    var curveConstants: CurvedRepeatableShapeConstants.Type {get}
    
    init()
}

extension CurvedRepeatableShape {
    
    
    /// Creates and returns a Dictionary of SegmentControllers, each of which controls some aspect
    /// of a curved segment of the oval. Each SegmentController contains the first and second control points
    /// for its segment. The four segments are "upper," "right," "lower," and "left." The points are all scaled
    /// to fit inside the given CGSize.
    /// - Parameter size: a CGSize into which the oval should fit.
    /// - Returns: a Dictionary with four SegmentControllers, keyed by SegmentName, each of whose points have been scaled
    /// to the given size.
    func controlPointsScaled(to size: CGSize) -> [SegmentName: SegmentController] {
        return curveConstants.controlFactors.mapValues{$0.scaled(to: size)}
    }
    
    /// Adds a single shape to the given path
    /// - Parameters:
    ///   - path: the Path that will be modified to include the new shape
    ///   - points: the end points delimiting the four segments of the shape
    ///   - controls: the four SegmentControllers that contain the control points of the curve of each segment
    private func addShapeTo(_ path: inout Path,
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
    
    /// Creates and returns a Path that draws a number of shapes, stacked vertically, the number of which is specified by
    /// the receiver's repetitions instance variable.
    /// Note that for shapes to look the same, no matter the number you draw, the rectangles should be proportional to the largest
    /// number of shapes you draw. E.g., if you are drawing a total of four shapes, your single shape rect should be one
    /// fourth the height of the quadruple-shape rect.
    /// - Parameter rect: a CGRect circumscribing all the shapes
    /// - Returns: a Path that draws the shapes
    private func shapes(in rect: CGRect) -> Path {
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
}
