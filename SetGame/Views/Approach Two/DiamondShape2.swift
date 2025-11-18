//
//  DiamondShape2.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 12/7/22.
//

import SwiftUI

/// A Shape that creates a path for a diamond. By default, it draws a single diamond, but can be configured to draw
/// any number of diamonds, stacked vertically, by initializing the shape with a number of repetitions
struct DiamondShape2: RepeatableShape {
    init() {
        self.shape = Rectangle()
    }
    
    var shape: any Shape
    
    /// The total number of diamonds to be drawn, stacked vertically, defaulting to one.
    var repetitions = 1
    
    /// The segments that make up the endpoints of a diamond, where each endpoint is a fraction of a unit so they can be scaled to the
    /// enclosing rectangle
    var segments: [any Segment] = DiamondConstants.segments

}
