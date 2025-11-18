//
//  ClosedRepeatableShape2.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 12/6/22.
//

import SwiftUI

/// A ClosedRepeatableShape draws a given number of shapes, each shape drawn with straight lines among a set of points,
/// circling around the points from the last to the first to close the shape. The entire set of shapes is scaled to its enclosing rectangle.
protocol RepeatableShape: Shape {
    
    /// The total number of shapes to be drawn, stacked vertically, defaulting to one.
    var repetitions: Int {get set}
    
    /// The shape to be repeated
    var shape: any Shape {get}
    
    /// An opportunity for the implementer of this protocol to initialize any instance variables
    init()
    
}

extension RepeatableShape {
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
    
    
    /// Creates and returns a Path that draws a number of shapes, stacked vertically, the number of which is specified by
    /// the receiver's repetitions instance variable.
    /// - Parameter rect: a CGRect circumscribing all the diamonds
    /// - Returns: a Path that draws the diamonds
    func path(in rect: CGRect) -> Path {


        // to fit all the repetitions into the space, we must divide the space up, vertically,
        // by the number of repetitions
        let divisor = Double(repetitions)
                
        // once you have the scaled segments, move them to the top of the CGRect
        let shapeSize = CGSize(width: rect.width, height: rect.height/divisor)
        var repeatedRect = CGRect(origin: rect.origin, size: shapeSize)

        let shift = rect.height/divisor // how far down to shift each rep
        
        var path = Path()
        
        var iteration = 1
        
        repeat {
            path.addPath(shape.path(in: repeatedRect))
            repeatedRect = CGRect(
                origin: (CGPoint(x: repeatedRect.origin.x, y: repeatedRect.origin.y + shift)),
                size: shapeSize)
            iteration += 1
        } while iteration <= repetitions
        
        return path
    }
}
