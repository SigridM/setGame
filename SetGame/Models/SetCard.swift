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
struct SetCard: Equatable, Identifiable {
    /// Each card has four features: shape, shading, color and number
    let shape: ShapeFeature
    let shading: ShadeFeature
    let color: ColorFeature
    let number: NumberFeature
    
    /// Each card starts out unselected and not part of either a correct set or a non-set
    private(set) var isSelected = false
    private(set) var isPartOfSet = false
    private(set) var isPartOfNonSet = false
    
    /// Answers a Boolean: whether the receiver forms a set with two other cards. This is true if all of the card's features
    /// form a set with the same features of the other two cards. The comparison must be made onlly among different cards;
    /// a card cannot form a set with itself.
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
    
    /// Turns selection on if it is off, and vice versa. If we've turned our selection off, we must no longer be part
    /// of either a set or non-set, so make those false as a side effect.
    mutating func toggleSelection() {
        isSelected = !isSelected
        if !isSelected {
            isPartOfSet = false
            isPartOfNonSet = false
        }
    }
    
    /// We form a set with two oither cards. Make note of that so we can somehow inform the user of this fact. Also, if we
    /// are part of a set, we cannot be part of a non-set, so change that, too.
    mutating func makePartOfSet() {
        isPartOfSet = true
        isPartOfNonSet = false
    }
    
    /// We form a non-set with two oither cards. Make note of that so we can somehow inform the user of this fact. Also, if we
    /// are part of a non-set, we cannot be part of a set, so change that, too.
    mutating func makePartOfNonSet() {
        isPartOfNonSet = true
        isPartOfSet = false
    }
    
    /// Turn on our seletion status, regardless of whether it was on before.
    mutating func select() {
        isSelected = true
    }
    
    /// Calculates an Int that uniquely identifies a single SetCard
    var id: Int {
        shape.rawValue * 1000
        + shading.rawValue * 100
        + color.rawValue * 10
        + number.rawValue
    }
}
