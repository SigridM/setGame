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

struct Card: Equatable {
    let shape: ShapeFeature
    let shading: ShadeFeature
    let color: ColorFeature
    let number: NumberFeature
    
    var isSelected = false
    
    func formsSetWith(_ secondCard: Card, and thirdCard: Card) -> Bool {
        return
            self.shape.formsSetWith(secondCard.shape, and: thirdCard.shape) &&
            self.shading.formsSetWith(secondCard.shading, and: thirdCard.shading) &&
            self.color.formsSetWith(secondCard.color, and: thirdCard.color) &&
            self.number.formsSetWith(secondCard.number, and: thirdCard.number)
    }
    
    mutating func toggleSelection() {
        isSelected = !isSelected
    }
    
    var id: Int {
        return shape.rawValue * 1000
            + shading.rawValue * 100
            + color.rawValue * 10
            + number.rawValue
    }
}

struct Deck {
    var cards: [Card]
    let initialDealCount = 12
    let subsequentDealCount = 3
    
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
        if isEmpty() {
            return []
        }
        return cards.popLast(subsequentDealCount)
    }
}

struct SetGame {
    private var deck: Deck
    var tableau: [Card]
    
    var hasSetSelected: Bool {
        return hasMaxSelected && tableau[0].formsSetWith(tableau[1], and: tableau[2])
    }
    
    private var hasMaxSelected: Bool {
        return numSelected == SetGameConstants.maxSelection
    }
    
    private var numSelected: Int {
        return selectedCardIndices.count
    }
    
    private var selectedCardIndices: [Int] {
        return tableau.indices(where:{$0.isSelected})
    }
    
    mutating func startGame() {
        deck = Deck.newDeck()
        tableau = deck.initialDeal()
    }
    
    func canSelect(_ card: Card) -> Bool {
        return !card.isSelected
    }
    
    func canDeselect(_ card: Card) -> Bool {
        return card.isSelected && !hasMaxSelected
    }
    
    mutating func select(_ card: Card) {
        let selectionIndex = tableau.firstIndex(where: {$0 == card})!
        if canSelect(card) {
            if hasMaxSelected {
                if hasSetSelected {
                    replaceSelectedSet()
                } else { // three selected; no set; deselect all
                    deselectAll()
                }
            }
            tableau[selectionIndex].toggleSelection()
        } else if canDeselect(card) {
            tableau[selectionIndex].toggleSelection()
        }

    }
    
    private mutating func deselectAll() {
        for index in selectedCardIndices {
            tableau[index].toggleSelection()
        }
    }
    private mutating func removeSelectedSet() {
        guard hasSetSelected else {
            return
        }
        for index in selectedCardIndices.reversed() {
            tableau.remove(at: index)
        }
    }
    
    private mutating func replaceSelectedSet() {
        guard hasSetSelected else {
            return
        }
        
        let newCards = deck.subsequentDeal()
        if newCards.isEmpty {
            removeSelectedSet()
        } else {
            for index in newCards.indices {
                tableau[selectedCardIndices[index]] = newCards[index]
            }
        }
    }
    
    mutating func addCards() {
        if hasSetSelected {
            replaceSelectedSet()
        } else {
            tableau += deck.subsequentDeal()
        }
    }
    
    func cardsRemaining() -> Bool {
        return !deck.isEmpty()
    }
}

struct SetGameConstants {
    static let maxSelection = 3
}
