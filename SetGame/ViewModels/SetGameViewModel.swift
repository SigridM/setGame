//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/8/22.
//

import SwiftUI

/// Acts as the go-between between the SetGame (model) and the SetGameView. Observable so whenever the model changes,
/// the view will change.
class SetGameViewModel: ObservableObject {
    
    /// The model, which is a SetGame. Publishd so whenever the model changes, the SetGameView will update.
    @Published var model = SetGame()
    
    /// Answers the Array of SetCards that are on the table at any given time during the play of a game
    /// - Returns: an Array of SetCards
    func cards() -> [SetCard] {
        model.tableau
    }
    
    /// Adds more cards to the tableau, if there are any more cards in the deck. If there is a proper set already selected,
    /// it replaces those cards on the tableau with new cards, if there are any more cards in the deck. Otherwise, the cards expand
    /// in size to fill the space available.
    func addCards() {
        model.addCards()
    }
    
    /// Asks the model to react to the user selecting the given card
    /// - Parameter card: a SetCard that is the card selected by the user
    func select(card: SetCard) {
        model.select(card)

    }
    
    /// Answers a Boolean, whether there are the maximum number of cards selected, but they do not make up a proper set.
    /// - Returns: a Bool for wheher there is a non-set selected
    func hasFullNonSetSelected() -> Bool {
        model.hasFullNonSetSelected()
    }
    
    /// Answers a Boolean, whether there exists on the tableau a collection of cards such that no proper set can be formed. This
    /// condition is called a "cap set." (If there are no cards left in the deck, this also means the game is over.)
    /// - Returns: a Bool, true if a cap set is on the tableau
    func hasCapSet() -> Bool {
        model.hasCapSet()
    }
    
    /// Indicate to the user the location of a set on the table. This is done by momentarily flashing the selection of that set.
    func showHint() {
        model.deselectAll()
        model.selectFirstSetOnTableau()
        let secondsToDelay = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
            self.model.deselectAll()
        }
    }
    
    /// Answers a Boolean, whether or not the game is complete, with no more sets available to make
    /// - Returns: a Bool, true if the game is complete
    func isOver() -> Bool {
        model.gameOver()
    }
    
    /// Answers a Boolean, whether or not the stock of cards in the deck is empty
    /// - Returns: a Bool, true if there are no more cards left to deal
    func deckEmpty() -> Bool {
        !model.cardsRemainingInDeck()
    }
    
    /// Asks the model to begin a new game.
    func newGame() {
        model.startGame()
    }
}

