//
//  SetGameView.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 9/26/22.
//

import SwiftUI

/// The View for the entire game of Set
struct SetGameView: View {
    @ObservedObject var game = SetGameViewModel()
    
    var body: some View {
        VStack {
            if game.isOver() {
                Text("Set Game - OVER!")
            } else if game.hasCapSet() {
                Text("Set Game (Add cards!)")
            } else if game.hasFullNonSetSelected() {
                Text("Set Game: Nope!")
            } else {
                Text("Set Game")
            }

            MinWidthAspectVGrid(
                items: game.cards(),
                aspectRatio: ViewConstants.cardAspectRatio,
                minWidth: ViewConstants.minCardWidth) { card, width in
                    CardView(card: card, width: width)
                        .onTapGesture {
                            game.select(card: card)
                        }
                }
                
            Spacer()
            HStack {
                Spacer()
                cardAdder
                Spacer()
                newGameInitiator
                Spacer()
                hinter
                Spacer()
            }
        }
    }
    
    /// An interface element that can add more cards to the tableau, if there are any left in the deck.
    var cardAdder: some View {
        Button {
            game.addCards()
        } label: {
            Text("Add Cards")
        }
        .disabled(game.deckEmpty())
    }
    
    /// An interface element that will show a hint for a set on the tableau if the user can't find one and needs help
    var hinter: some View {
        Button {
            game.showHint()
        } label: {
            Text("Show Hint")
        }
        .disabled(game.isOver())
    }
    
    /// An interface element that will start a new game
    var newGameInitiator: some View {
        Button {
            game.newGame()
        } label: {
            Text("New Game")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView()
    }
}

