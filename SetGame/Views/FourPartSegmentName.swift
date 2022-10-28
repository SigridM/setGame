//
//  FourPartSegmentName.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/24/22.
//

import Foundation

/// An enumeration naming the four possible segments of a CurvedClosedRepeatableShape (e.g., Squiggle or Oval).
/// The four segment names are: upper, right, lower, and left. Each has the raw value of the index of the point in the
/// corresponding points array where the segment ends, which helps with iterating through drawing.
enum FourPartSegmentName: Int, CaseIterable {
    
    case upper = 1
    case right = 2
    case lower = 3
    case left = 0
    
}
