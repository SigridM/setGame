//
//  SetDeck.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/6/22.
//

import Foundation

/// A structure that encapsulates the standard card deck of a Set game. It can create a new, shuffled deck, can deal the initial number
/// of cards, can deal the subsequent number of cards, and can report whether it is empty.
struct SetDeck {
    var cards: [SetCard]
    
    
    /// Factory method for creating a new, shuffled deck of SetCards. Each card is unique, made up of a combination of
    /// shape, shading, color and number of symbols on the card.
    /// - Returns: A new SetDeck containing all of the unique cards.
    static func newDeck() -> SetDeck {
        var cardArray: [SetCard] = []
        for shape in ShapeFeature.allCases {
            for shading in ShadeFeature.allCases {
                for color in ColorFeature.allCases {
                    for number in NumberFeature.allCases {
                        cardArray.append(SetCard(shape: shape,
                                                 shading: shading,
                                                 color: color,
                                                 number: number))
                    }
                }
            }
        }
        return SetDeck(cards: cardArray.shuffled())
    }
    
    
    /// For testing purposes, create a deck with only a subset of the cards. This will allow us to get through a game faster during testing.
    /// Factory method for creating a new, shuffled deck of SetCards. Each card is unique, made up of a combination of
    /// shape, shading and color, but with the same number of symbols.
    /// - Returns: A new SetDeck containing a subset of all of the unique cards.
    static func newLimitedDeck() -> SetDeck {
        var cardArray: [SetCard] = []
        for shape in ShapeFeature.allCases {
            for shading in ShadeFeature.allCases {
                for color in ColorFeature.allCases {
                    cardArray.append(SetCard(shape: shape,
                                             shading: shading,
                                             color: color,
                                             number: NumberFeature.one))
                }
            }
        }
        return SetDeck(cards: cardArray.shuffled())
    }
    
    /// For testing purposes, create a deck with a very small subset of the cards. This will allow us to get through a game fastest.
    /// Factory method for creating a new, shuffled deck of SetCards. Each card is unique, made up of a combination of
    /// shape and shading, but with the same color and number of symbols.
    /// - Returns: A new SetDeck containing a subset of all of the unique cards.
    static func newVeryLimitedDeck() -> SetDeck {
        var cardArray: [SetCard] = []
        for shape in ShapeFeature.allCases {
            for shading in ShadeFeature.allCases {
                cardArray.append(SetCard(shape: shape,
                                         shading: shading,
                                         color: ColorFeature.color1,
                                         number: NumberFeature.one))
            }
        }
        return SetDeck(cards: cardArray.shuffled())
    }
    
    /// Answers a Boolean: whether or not the deck has no more cards left to deal
    /// - Returns: a Boolean, true if there are no more cards left
    func isEmpty() -> Bool {
        cards.isEmpty
    }
    
    /// Removes the top n cards from the deck, where n is the initial deal size defined by the game, and returns them in an Array.
    /// (If there are fewer than n cards in the deck, it will return an Array containing as many as it can from the deck.)
    /// - Returns: an Array of SetCards containing the top n cards in the deck.
    mutating func initialDeal() -> [SetCard] {
        cards.popLast(SetGameConstants.initialDealSize)
    }
    
    /// Removes the top m cards from the deck, where m is the subsequent deal size defined by the game,
    /// and returns them in an Array.
    /// (If there are fewer than m cards in the deck, it will return an Array containing as many as it can from the deck, possibly an
    /// empty array.)
    /// - Returns: an Array of SetCards containing the top m cards in the deck.
    mutating func subsequentDeal() -> [SetCard] {
        cards.popLast(SetGameConstants.setSize)
    }
}
