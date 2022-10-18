//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/8/22.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published var model = SetGame()
    
    func cards() -> [SetCard] {
        model.tableau
    }
    
    func addCards() {
        model.addCards()
    }
    
    func select(card: SetCard) {
        model.select(card)
//        print("selected tableau: \(model.tableau)")

    }
    func hasFullNonSetSelected() -> Bool {
        model.hasFullNonSetSelected()
    }
    
    func hasCapSet() -> Bool {
        model.hasCapSet()
    }
    
    func showHint() {
        model.deselectAll()
        model.selectFirstSetOnTableau()
        let secondsToDelay = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
            self.model.deselectAll()
        }
    }
    func isOver() -> Bool {
        model.gameOver()
    }
    
    func deckEmpty() -> Bool {
        !model.cardsRemainingInDeck()
    }
    
    func newGame() {
        model.startGame()
    }
}

