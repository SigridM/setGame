//
//  SetFeature.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 9/26/22.
//

import Foundation

/// A protocol that defines the behavior of an individual feature (shape, shade, color, or number) of a Set game card.
protocol SetFeature: Equatable, CaseIterable {
    /// A SetFeature must be able to determine whether it forms a set with two other features of the same type
    /// - Parameters:
    ///   - secondFeature: a SetFeature that is of the same type as the receiver and is a candidate for forming a set with the
    ///   third feature and the receiver.
    ///   - thirdFeature: a SetFeature that is of the same type as the receiver and is a candidate for forming a set with the
    ///   second feature and the receiver.
    /// - Returns: a Boolean, true if all three features form a proper set
    func formsSetWith(_ secondFeature: Self, and thirdFeature: Self) -> Bool
}

extension SetFeature {
    /// The default behavior that determines whether it forms a set with two other features of the same type
    /// - Parameters:
    ///   - secondFeature: a SetFeature that is of the same type as the receiver and is a candidate for forming a set with the
    ///   third feature and the receiver.
    ///   - thirdFeature: a SetFeature that is of the same type as the receiver and is a candidate for forming a set with the
    ///   second feature and the receiver.
    /// - Returns: a Boolean, true if all three features form a proper set. It is a proper set if either all features are the same, or all
    /// features are different.
    func formsSetWith(_ secondFeature: Self, and thirdFeature: Self) -> Bool {
        if self == secondFeature && self == thirdFeature {
            return true
        }
        if self != secondFeature && self != thirdFeature && secondFeature != thirdFeature {
            return true
        }
        return false
    }
}
/// A SetFeature that is one of three different shapes. Has a rawValue so the feature can be used to form a unique ID for a SetCard.
enum ShapeFeature: Int, SetFeature {
    case shape1 = 1
    case shape2 = 2
    case shape3 = 3
}

/// A SetFeature that is one of three different shades. Has a rawValue so the feature can be used to form a unique ID for a SetCard.
enum ShadeFeature: Int, SetFeature {
    case shade1 = 1
    case shade2 = 2
    case shade3 = 3
}

/// A SetFeature that is one of three different colors. Has a rawValue so the feature can be used to form a unique ID for a SetCard.
/// Made zero-relative so it can be used as an index into an array.
enum ColorFeature: Int, SetFeature {
    case color1 = 0
    case color2 = 1
    case color3 = 2
}

/// A SetFeature that is one of three different numbers. Has a rawValue so the feature can be used to form a unique ID for a SetCard.
enum NumberFeature: Int, SetFeature {
    case one = 1
    case two = 2
    case three = 3
}




