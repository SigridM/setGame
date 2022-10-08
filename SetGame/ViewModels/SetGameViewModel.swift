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
}

