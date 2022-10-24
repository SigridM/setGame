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
    private var deck: SetDeck<SetCard>
    
    /// An enum designating which of three significant states of selection the game can be in: with less than the maximum number of
    /// cards selected; with the maximum number selected but no proper set formed, or with the maximum number of cards
    /// selected and a proper set formed
    private var selectionState: SelectionState
    
    /// An Array of SetCards that are on the table.
    var tableau: [SetCard]
    
    /// The state that says we are in the middle of providing a hint to the user to prompt them to add cards. This must be
    /// in the model because the model is published, so when it changes, the UI will change.
    var inAddCardsHint = false
    
    /// The game keeps track of the running score
    private(set) var score = 0.0
    
    // MARK: Computed inst vars
    /// A Boolean that is true if we have a selection containing a full set.
    var hasSetSelected: Bool {
        let indices = selectedCardIndices
        return hasMaxSelected && tableau[indices[0]]
            .formsSetWith(tableau[indices[1]], and: tableau[indices[2]])
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
            let selectedIndices = selectedCardIndices
            for index in newCards.indices {
                tableau[selectedIndices[index]] = newCards[index]
            }
        }
    }
    
    /// Searches for a set on the tableau and returns the indices into that set, if there is one, otherwise returns nil
    /// - Returns: An array of Ints that are the indices of the first three SetCards forming a set, if there is one, otherwise nil
    private func indicesOfSetOnTableau() -> [Int]? {
        for i in tableau.indices {
            for j in i+1..<tableau.count {
                for k in j+1..<tableau.count {
                    if tableau[i].formsSetWith(tableau[j], and: tableau[k]) {
                        return [i, j, k]
                    }
                }
            }
        }
        return nil // Got all the way through without finding a set
    }
    
    /// Iterates through each card that is currently selected and performs the given action on that card
    /// - Parameter action: a closure that modifies the given card
    private mutating func forSelectionsDo(_ action: (inout SetCard) -> Void) {
        for index in selectedCardIndices {
            action(&tableau[index])
        }
    }
    
    /// Deselects all the selected cards in the tableau and then selects the card at the given index
    /// - Parameter index: an Int for the given index
    private mutating func selectOnlyAt(_ index: Int) {
        deselectAll()
        tableau[index].select()
    }
    

    // MARK: Public Functions
    
    init() {
        deck = SetDeck.newLimitedDeck()
        tableau = deck.initialDeal()
        selectionState = .lessThanMaxSelected
    }
    
    /// Begin a neew game by getting a new, shuffled deck of cards and putting the initial deal from those cards onto the tableau.
    /// Since there will be no cards selected at the beginning of the game, set the selectionState to .lessThanMaxSelected
    mutating func startGame() {
        deck = SetDeck.newDeck()
        tableau = deck.initialDeal()
        selectionState = .lessThanMaxSelected
        score = 0.0
    }

    /// Answers a Boolean: whether a game is already in progress
    /// - Returns: a Boolean for whether the game has begun
    func gameHasBegun() -> Bool {
        !tableau.isEmpty && !gameOver()
    }
    
    /// Add a subsequent deal to the tableau. If we have a set selected already, replace that set with the new
    /// cards. Otherwise, add cards to the tableau.
    mutating func addCards() {
        guard gameHasBegun() else {return} // can't add cards if we haven't started yet
        if hasSetSelected {
            replaceSelectedSet()
            selectionState = .lessThanMaxSelected
        } else {
            if !hasCapSet() && !deck.isEmpty() {
                decreaseScore()
            }
            tableau += deck.subsequentDeal()
        }
    }
    /// React to the selection of a particular card. This will be done by moving from the current selectionState to the
    /// next selectionState. See SelectionState for details.
    /// - Parameter card: the SetCard attempting to be selected or deselected
    mutating func select(_ card: SetCard) {
        let selectionIndex = tableau.firstIndex(where: {$0.id == card.id})!
        selectionState = selectionState.goToNextState(selectedAt: selectionIndex, in: &self)
    }
    
    /// Remove the selection status from all the cards that are selected
    mutating func deselectAll() {
        for index in selectedCardIndices {
            tableau[index].toggleSelection()
        }
    }
    
    /// The user has had some success; increase the score by a fixed amount
    mutating func increaseScore() {
        score += SetGameConstants.reward
    }
    
    /// The user has had a failure of some kind (could be a mismatch; could be a hint); decrease the score by a fixed amount
    mutating func decreaseScore() {
        score += SetGameConstants.penalty
    }
    
    /// Enumerates which of three possible states of selection a SetGame can be in:  with less than the maximum number
    /// selected; with the maximum selected but the selected cards not forming a proper set; or with the maximum selected
    /// and the selected cards forming a set.
    private enum SelectionState {
        case lessThanMaxSelected
        case maxSelectedAsSet
        case maxSelectedAsNonSet
        
        /// Move from the current selectionState to the next selectionState, based on what happens as a result of selecting
        /// the card at the given index in the given game's tableau.
        ///
        /// If we have less than max selected, we can always toggle the selection at the given index. After that, though,
        /// the next selectionState will depend on how many are now selected and whether the selection forms a set.
        /// After determining which selectionState to go to next, make certain the cards know whether or not they are part
        /// of a set or non-set and return the next selectionState.
        ///
        /// If we have the max selected, it is either because we have a set selected or a non-set selected. In either case,
        /// the next selectionState will retun to .lessThanMaxSelected. But before that, the game must either replace the selected set
        /// or select only at the current selection. Do that, then return the new selectionState.
        ///
        /// - Parameters:
        ///   - index: an Int that is an index into the game's tableau of the current selection
        ///   - game: the SetGame holding onto the current selectionState
        /// - Returns: a SelectionState that is the next selectionState to which we are transitioning
        func goToNextState(selectedAt index: Int, in game: inout SetGame) -> SelectionState {
            switch self {
                case .lessThanMaxSelected :
                    // if less than the maximum selected, we can always toggle the selection
                    game.tableau[index].toggleSelection()
                    
                    // then, see what selectionState to go to next
                    if !game.hasMaxSelected {
                        return .lessThanMaxSelected
                    }
                    if game.hasSetSelected {
                        game.forSelectionsDo{card in card.makePartOfSet()}
                        game.increaseScore()
                        return .maxSelectedAsSet
                    } else {
                        game.forSelectionsDo{card in card.makePartOfNonSet()}
                        game.decreaseScore()
                        return .maxSelectedAsNonSet
                    }
                    
                case .maxSelectedAsSet :
                    game.replaceSelectedSet()
                    return .lessThanMaxSelected
                    
                case .maxSelectedAsNonSet :
                    game.selectOnlyAt(index)  // select only the clicked card
                    return .lessThanMaxSelected
            }
        }
    } // end SelectionState enum

    /// Answers a Boolean: whether or not there are the maximum number of cards selected, but they do not form a proper set
    /// - Returns: a Bool for whether a full non-set is selected
    func hasFullNonSetSelected() -> Bool {
        if !hasMaxSelected { return false}
        for index in selectedCardIndices {
            if !tableau[index].isPartOfNonSet {return false}
        }
        return true
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
        if tableau.count > SetGameConstants.minimumCapSetSize {return false}
        return indicesOfSetOnTableau() == nil
    }
    
    /// Answers whether the game is complete: either all cards have been made into a set, or there are no more sets.
    /// - Returns: a Boolean telling whether the game is complete
    func gameOver() -> Bool {
        if !deck.isEmpty() {return false} //game can't be over if there are still more cards to deal
        return
            (tableau.count < SetGameConstants.setSize)
            || hasCapSet()
    }
    
    /// As part of a hint, find the first proper set on the table and select those cards.
    mutating func selectFirstSetOnTableau() {
        if let indices = indicesOfSetOnTableau() {
            for index in indices {
                tableau[index].select()
            }
        }
    }
}
