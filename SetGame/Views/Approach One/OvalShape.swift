//
//  OvalShape.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 9/26/22.
//

import SwiftUI

/// A Shape that creates a path for an oval. By default, it draws a single oval, but can be configured to draw
/// any number of ovals, stacked vertically, by initializing the shape with a number of repetitions
struct OvalShape: CurvedClosedRepeatableShape {
    
    var repetitions = 1
    var pointFactors = OvalConstants.pointFactors
    var controlFactors = OvalConstants.controlFactors
    typealias SegmentKey = FourPartSegmentName
    
    /// Required initializer for conformance to ClosedRepeatableShape protocol
    init() {
        self.repetitions = 1
        self.pointFactors = OvalConstants.pointFactors
        self.controlFactors = OvalConstants.controlFactors
    }

} // end OvalShape

