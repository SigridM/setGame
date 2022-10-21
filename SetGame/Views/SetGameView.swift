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
    
    /// A Boolean State, true if, when the user clicks on a  the new game button, we need to show an alert
    @State private var needsNewGameAlert: Bool = false
    
    /// Creates and returns the main view for the SetGame
    var body: some View {
        VStack {
            VStack {
                title
                score
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
    
    /// Returns a Text view that shows the title of the game, along with some additional information
    private var title: some View {
        if game.isOver() {
            return Text("Set Game - OVER!" )
        } else if game.hasCapSet() {
            return Text("Set Game (Add cards!)")
        } else if game.hasFullNonSetSelected() {
            return Text("Set Game: Nope!")
        } else {
            return Text("Set Game")
        }
    }
    
    /// Returns a Text view that shows the current score of the game
    private var score: some View {
        Text("SCORE: \(Int(game.score()))")
    }
    
    /// An interface element that can add more cards to the tableau, if there are any left in the deck.
    var cardAdder: some View {
        Button {
            game.addCards()
        } label: {
            Label("Add Cards", systemImage: ViewConstants.addImageName)
        }
        .disabled(game.deckEmpty())
    }
    
    /// An interface element that will show a hint for a set on the tableau if the user can't find one and needs help
    var hinter: some View {
        Button {
            game.showHint()
        } label: {
            Label("Show Hint", systemImage: ViewConstants.hintImageName)
        }
        .disabled(game.isOver())

  
    }
    
    /// A UI element that, when selected, initiates a new game with a random theme;
    /// Pops up an alert to confirm that we want a new game if the current game is underway and not complete
    private var newGameInitiator: some View {
        let features = GameChangingFeature(
            imageName: ViewConstants.newGameImageName,
            buttonText: "New Game",
            needsAlert: _needsNewGameAlert,
            continueAction: game.newGame,
            alertMessage: ViewConstants.newGameAlertMessage,
            game: game
        )
        return features.gameChanger()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView()
    }
}

