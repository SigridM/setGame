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
    var pointFactors = SquiggleConstants.downLeftPointFactors
    var controlFactors = SquiggleConstants.downLeftControlFactors
    typealias SegmentKey = FourPartSegmentName
    
    var direction: Double {
        get {
            if pointFactors == SquiggleConstants.downLeftPointFactors {
                return 1.0
            } else {
                return -1.0
            }
        }
        set {
            if newValue == 1.0 {
                pointFactors = SquiggleConstants.downLeftPointFactors
                controlFactors = SquiggleConstants.downLeftControlFactors
            } else {
                pointFactors = SquiggleConstants.upLeftPointFactors
                controlFactors = SquiggleConstants.upLeftControlFactors
            }
        }
    }
    
    /// Required initializer for conformance to ClosedRepeatableShape protocol
    init() {
        self.repetitions = 1
        self.pointFactors = SquiggleConstants.downLeftPointFactors
        self.controlFactors = SquiggleConstants.downLeftControlFactors
    }
    
    init(repetitions: Int = 1, pointFactors: [CGPoint] = SquiggleConstants.downLeftPointFactors, controlFactors: [FourPartSegmentName : SegmentController] = SquiggleConstants.downLeftControlFactors, direction: Double = 1.0) {
        self.repetitions = repetitions
        self.pointFactors = pointFactors
        self.controlFactors = controlFactors
        self.direction = direction
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
            ForEach(0..<colors.count, id: \.self) { index in
                Self(repetitions: repetitions, direction: self.direction)
                    .dotsPath(in: rect, from: index)
                    .foregroundColor(colors[index])
                    .opacity(0.75)
            }
        }
    }
   
} // end SquiggleShape


