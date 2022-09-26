//
//  SetGameModels.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 9/26/22.
//

import Foundation

protocol SetFeature: Equatable {
    func formsSetWith<T:SetFeature>(_ secondFeature: T, and thirdFeature: T) -> Bool
}

extension SetFeature {
    func formsSetWith<T: SetFeature>(_ secondFeature: T, and thirdFeature: T) -> Bool {
        if self == secondFeature && self == thirdFeature {
            return true
        }
        if self != secondFeature && self != thirdFeature && secondFeature != thirdFeature {
            return true
        }
        return false
    }
}
