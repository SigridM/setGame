//
//  RepeatableShape.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/24/22.
//

import SwiftUI

protocol RepeatableShape: Shape {
    var repetitions = 1
}

extension RepeatableShape {
    init() {
        self.repetitions = 1
    }
    
    init(_ repetitions: Int) {
        guard repetitions > 0 else {
            self.repetitions = 1
            return
        }
        self.repetitions = repetitions
    }
    
    /// Creates and returns an array of the four CGPoints delimiting the four segments of the oval, scaled to
    /// the given CGSize
    /// - Parameter size: a CGSize into which the oval should fit.
    /// - Returns: an Array of four CGPoints
    private func pointsScaled(to size: CGSize) -> [CGPoint] {
        let scaling = CGAffineTransform(scaleX: size.width, y: size.height)
        return Self.pointFactors.map{$0.applying(scaling)}
    }
    
}
