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
}
