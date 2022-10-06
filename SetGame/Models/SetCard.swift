//
//  SetCard.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/6/22.
//

import Foundation

/// A struct for encapsulating the structure and behavior of a single card in the game of Set. Each SetCard has four features (shape,
/// shading, color, and number of symbols) and can determine whether it forms a set with any other two SetCards. It also has a mutable
/// state: a Boolean indicating whether the SetCard is currently selected.
struct SetCard: Equatable {
    let shape: ShapeFeature
    let shading: ShadeFeature
    let color: ColorFeature
    let number: NumberFeature
    
    var isSelected = false
    
    /// Answers a Boolean: whether the receiver forms a set with two other cards.
    /// - Parameters:
    ///   - secondCard: a SetCard (that must not be the receiver) that is potentially part of the set
    ///   - thirdCard: a SetCard (that must not be the receiver or the secondCard) that is potentially part of the set
    /// - Returns: a Boolean, true if the three cards together form a proper set
    func formsSetWith(_ secondCard: SetCard, and thirdCard: SetCard) -> Bool {
        
        guard secondCard != self && thirdCard != self && secondCard != thirdCard else {
            return false
        }
        return
            self.shape.formsSetWith(secondCard.shape, and: thirdCard.shape) &&
            self.shading.formsSetWith(secondCard.shading, and: thirdCard.shading) &&
            self.color.formsSetWith(secondCard.color, and: thirdCard.color) &&
            self.number.formsSetWith(secondCard.number, and: thirdCard.number)
    }
    
    /// Turns selection on if it is off, and vice versa
    mutating func toggleSelection() {
        isSelected = !isSelected
    }
    
    /// A unique Int that identifies a single SetCard
    var id: Int {
        return shape.rawValue * 1000
        + shading.rawValue * 100
        + color.rawValue * 10
        + number.rawValue
    }
}
