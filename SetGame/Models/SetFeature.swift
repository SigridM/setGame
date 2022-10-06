//
//  SetFeature.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 9/26/22.
//

import Foundation

protocol SetFeature: Equatable, CaseIterable {}

extension SetFeature {
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
enum ShapeFeature: Int, SetFeature {
    case shape1 = 1
    case shape2 = 2
    case shape3 = 3
}

enum ShadeFeature: Int, SetFeature {
    case shade1 = 1
    case shade2 = 2
    case shade3 = 3
}

enum ColorFeature: Int, SetFeature {
    case color1 = 1
    case color2 = 2
    case color3 = 3
}

enum NumberFeature: Int, SetFeature {
    case one = 1
    case two = 2
    case three = 3
}




