//
//  DiamondShape.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 9/26/22.
//

import SwiftUI

/// A Shape that creates a path for a diamond. By default, it draws a single diamond, but can be configured to draw
/// any number of diamonds, stacked vertically, by initializing the shape with a number of repetitions
struct DiamondShape: ClosedRepeatableShape {
    
    /// The total number of diamonds to be drawn, stacked vertically, defaulting to one.
    var repetitions = 1
    
    /// The points that make up the endpoints of a diamond, represented as fractions of a unit so they can be scaled to the
    /// enclosing rectangle
    var pointFactors = DiamondConstants.pointFactors
    
    /// Required initializer for conformance to ClosedRepeatableShape protocol
    init() {
        self.repetitions = 1
        self.pointFactors = DiamondConstants.pointFactors
    }
    
}

