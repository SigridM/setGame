//
//  SetGame.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/6/22.
//

import Foundation

/// The Model that forms the logic for a game of Set
struct SetGame {
    
    // MARK: - Instance variables
    /// The deck of SetCards from which we will be drawing cards.
    private var deck: SetDeck
    
    /// An Array of SetCards that are on the table.
    var tableau: [SetCard]
    
    /// A Boolean that is true if we have a selection containing a full set.
    var hasSetSelected: Bool {
        hasMaxSelected && tableau[0].formsSetWith(tableau[1], and: tableau[2])
    }
    
    /// A Boolean that is true if we already have selected the maximum number of cards that are allowed to be
    /// selected at one time.
    private var hasMaxSelected: Bool {
        numSelected == SetGameConstants.setSize
    }
    
    /// An Int for the number of cards currently selected
    private var numSelected: Int {
        selectedCardIndices.count
    }
    
    /// An Array of Ints containing the indices into the tableau of all the cards that are selected
    private var selectedCardIndices: [Int] {
        tableau.indices(where:{$0.isSelected})
    }
    
 
    // MARK: - Private Functions
    
    /// Answers a Boolean for whether a given card can be selected. It can be selected if it isn't already selected.
    /// - Parameter card: the SetCard attempting to be selected
    /// - Returns: a Boolean for whether selecting that card is allowed
    private func canSelect(_ card: SetCard) -> Bool {
        !card.isSelected
    }
    
    /// Answers a Boolean for whether or not a given card can be deselected. It can only be deselected if it is already selected
    /// and if we don't already have the maximum number of cards selected that can be selected (which would be like trying to
    /// have a do-over on the current attempt at forming a set).
    /// - Parameter card: the SetCard attempting to be deselected
    /// - Returns: a Boolean for whether deselecting the given card is allowed.
    private func canDeselect(_ card: SetCard) -> Bool {
        card.isSelected && !hasMaxSelected
    }
    
    /// React to the selection of a particular card.
    /// A card can only be selected if it is not already selected. If that is the case:
    ///     1. If a set is already successfully selected, replace the selected set with a subsequent deal
    ///     2. If the maximum number of cards are selected that don't form a set, deselect all of those cards
    ///     In either case, select the given card.
    /// If a card cannot be selected because it is already selected, try to deselect the card. This can only
    /// happen if we don't already have the maximum number of cards selected. If there are already the
    /// maximum selected, attempting to deselect a selected card has no effect.
    /// - Parameter card: the SetCard attempting to be selected or deselected
    mutating func select(_ card: SetCard) {
        let selectionIndex = tableau.firstIndex(where: {$0 == card})!
        if canSelect(card) {
            if hasSetSelected {
                replaceSelectedSet()
            } else if hasMaxSelected { // three selected; no set; deselect all
                deselectAll()
            }
            tableau[selectionIndex].toggleSelection()
        } else if canDeselect(card) {
            tableau[selectionIndex].toggleSelection()
        }
        
    }
    
    /// Remove the selection status from all the cards that are selected
    private mutating func deselectAll() {
        for index in selectedCardIndices {
            tableau[index].toggleSelection()
        }
    }
    /// If there is a selected set, remove it from the tableau
    private mutating func removeSelectedSet() {
        guard hasSetSelected else {
            return
        }
        
        // Note that the indices are removed in reverse to avoid changing the order of the cards
        // as we remove them
        for index in selectedCardIndices.reversed() {
            tableau.remove(at: index)
        }
    }
    
    /// If there is a selected set, replace those cards with a subsequent deal. If there are no more cards left to deal, just remove
    /// those cards.
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
    
    // MARK: Public Functions
    
    /// Begin the game by getting a new, shuffled deck of cards and putting the initial deal from those cards onto the tableau
    mutating func startGame() {
        deck = SetDeck.newDeck()
        tableau = deck.initialDeal()
    }
    
    /// Answers a Boolean: whether a game is already in progress
    /// - Returns: a Boolean for whether the game has begun
    func gameHasBegun() -> Bool {
        !tableau.isEmpty
    }
    
    /// Add a subsequent deal to the tableau. If we have a set selected already, replace that set with the new
    /// cards. Otherwise, add cards to the tableau.
    mutating func addCards() {
        guard gameHasBegun() else {return} // can't add cards if we haven't started yet
        if hasSetSelected {
            replaceSelectedSet()
        } else {
            tableau += deck.subsequentDeal()
        }
    }
    
    /// Answers whether or not there are any cards remaining to be dealt
    /// - Returns: a Boolean for whether or not there are cards remaining to be dealt
    func cardsRemainingInDeck() -> Bool {
        !deck.isEmpty()
    }
    
    /// Answers a Boolean: whether there is a cap set on the table, where a cap set is defined as a layout in which no set can be made
    /// - Returns: A Boolean for whether or not a cap set is on the tableau
    func hasCapSet() -> Bool {
        // optimization: the smallest possible cap set is 20 cards; if more than that, there must
        // be a set (no cap set)
        if tableau.count > 20 {return false}
        return setOnTableau() != nil
    }
    
    /// Answers whether the game is complete: either all cards have been made into a set, or there are no more sets.
    /// - Returns: a Boolean telling whether the game is complete
    func gameOver() -> Bool {
        if !deck.isEmpty() {return false} //game can't be over if there are still more cards to deal
        return
            (tableau.count <= SetGameConstants.setSize)
            || hasCapSet()
    }
    
    /// Searches for a set on the tableau and returns it if there is one, otherwise returns nil
    /// - Returns: An array of the first three SetCards forming a set, if there is one, otherwise nil
    func setOnTableau() -> [SetCard]? {
        for i in tableau.indices {
            for j in i+1..<tableau.count {
                for k in j+1..<tableau.count {
                    if tableau[i].formsSetWith(tableau[j], and: tableau[k]) {
                        return [tableau[i], tableau[j], tableau[k]]
                    }
                }
            }
        }
        return nil // Got all the way through without finding a set
    }
}
