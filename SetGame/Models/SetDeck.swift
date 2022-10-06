//
//  SetDeck.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/6/22.
//

import Foundation

struct SetDeck {
    var cards: [SetCard]
    
    
    static func newDeck() -> SetDeck {
        var cardArray: [SetCard] = []
        for shape in ShapeFeature.allCases {
            for shading in ShadeFeature.allCases {
                for color in ColorFeature.allCases {
                    for number in NumberFeature.allCases {
                        cardArray.append(SetCard(shape: shape, shading: shading, color: color, number: number))
                    }
                }
            }
        }
        return SetDeck(cards: cardArray.shuffled())
    }
    
    func isEmpty() -> Bool {
        return cards.isEmpty
    }
    
    mutating func initialDeal() -> [SetCard] {
        return cards.popLast(SetGameConstants.initialDealSize)
    }
    
    mutating func subsequentDeal() -> [SetCard] {
        if isEmpty() {
            return []
        }
        return cards.popLast(SetGameConstants.setSize)
    }
}
