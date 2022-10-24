//
//  SetGameConstants.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/6/22.
//

import Foundation

/// A struct for encapuslating the constants in a Set game.
struct SetGameConstants {
    /// The number of cards that make up a set
    static let setSize = 3
    /// The number of cards that should be dealt when the game begins.
    static let initialDealSize = setSize * 4
    
    /// In a traditional game of Set, there can be no cap set if we have more than 20 cards in the tableau
    static let minimumCapSetSize = 20
    
    /// The change in score when a set is formed
    static let reward = 2.0
    
    /// The change in score when a non-set is formed, or a hint is offered, or more cards are added when there is not a cap set
    static let penalty = -1.0
    
}
