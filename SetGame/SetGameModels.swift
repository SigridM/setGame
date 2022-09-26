//
//  SetGameModels.swift
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
enum ShapeFeature: SetFeature {
    case triangle
    case squiggle
    case diamond
}

enum ShadeFeature: SetFeature {
    case outline
    case shaded
    case solid
}

enum ColorFeature: SetFeature {
    case color1
    case color2
    case color3
}

enum NumberFeature: SetFeature {
    case one
    case two
    case three
}

struct Card {
    let shape: ShapeFeature
    let shading: ShadeFeature
    let color: ColorFeature
    let number: NumberFeature
    
    func formsSetWith(_ secondCard: Card, and thirdCard: Card) -> Bool {
        return
            self.shape.formsSetWith(secondCard.shape, and: thirdCard.shape) &&
            self.shading.formsSetWith(secondCard.shading, and: thirdCard.shading) &&
            self.color.formsSetWith(secondCard.color, and: thirdCard.color) &&
            self.number.formsSetWith(secondCard.number, and: thirdCard.number)
    }
}

struct Deck {
    var cards: [Card]
    var initialDealCount = 12
    var subsequentDealCount = 3
    
    static func newDeck() -> Deck {
        var cardArray: [Card] = []
        for shape in ShapeFeature.allCases {
            for shading in ShadeFeature.allCases {
                for color in ColorFeature.allCases {
                    for number in NumberFeature.allCases {
                        cardArray.append(Card(shape: shape, shading: shading, color: color, number: number))
                    }
                }
            }
        }
        return Deck(cards: cardArray.shuffled())
    }
    
    func isEmpty() -> Bool {
        return cards.isEmpty
    }
    
    mutating func initialDeal() -> [Card] {
        return cards.popLast(initialDealCount)
    }

    mutating func subsequentDeal() -> [Card] {
        return cards.popLast(subsequentDealCount)
    }
}
