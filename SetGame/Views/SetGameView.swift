//
//  SetGameView.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 9/26/22.
//

import SwiftUI

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

            AspectVGrid(items: game.cards(), aspectRatio: 2.0/3.0, minWidth: 55) { card, width in
                CardView(card: card)
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
//            .padding(2.0)
        }
    }
    
    var cardAdder: some View {
        Button {
            game.addCards()
        } label: {
            Text("Add Cards")
        }
        .disabled(game.deckEmpty())
    }
    
    var hinter: some View {
        Button {
            game.showHint()
        } label: {
            Text("Show Hint")
        }
        .disabled(game.isOver())
    }
    
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

struct CardView: View {
    let card: SetCard
    private let colors: [Color] = [.red, .green, .blue]
    
    var body: some View {
         GeometryReader { geometry in
            let answer = ZStack {
                let inset = 12.0
                rectForCard(in: geometry.size)
                viewForCard(in: geometry.size - inset * 2)
                    .padding(EdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset))
            }
             if card.isPartOfSet {
                 answer.opacity(0.25)
             } else {
                 answer.opacity(1.0)
             }

        }
    }
    
    private func rectForCard(in size: CGSize) -> some View {
        var borderWidth: Double
        var color: Color
        if card.isSelected {
            borderWidth = 6.0
        } else {
            borderWidth = 3.0
        }
        if card.isPartOfNonSet {
            color = .black
        } else {
            color = .gray // colors[card.color.rawValue]
        }
        let rect = RoundedRectangle(cornerRadius: size.width / 4.0)
                .strokeBorder(style: StrokeStyle(lineWidth: borderWidth))
                .foregroundColor(color)
        return rect
    }
    
    @ViewBuilder
    private func viewForCard(in size: CGSize) -> some View {
        
        switch card.shading {
            case .shade1 : // patterned (shaded)
                let image = Image(systemName: "circle.grid.3x3")
                let bottomView = pathForCard(in: size)
                    .foregroundColor(colors[card.color.rawValue])
                    .opacity(0.65)
                let topView = pathForCard(in: size)
                    .foregroundStyle(.image(image))
                    .opacity(0.55)
                ZStack {
                    bottomView
                    topView
                }
            case.shade2 :  // stroked (outlined)
                pathForCard(in: size)
                    .strokedPath(StrokeStyle(lineWidth: 3.0))
                    .foregroundColor(colors[card.color.rawValue])
            case .shade3 : // filled
                pathForCard(in: size)
                    .foregroundColor(colors[card.color.rawValue])
        }

    }
    
    private func pathForCard(in size: CGSize) -> Path {
        let height = size.height *
            Double(card.number.rawValue) / Double(NumberFeature.allCases.count) -
        2.0
        let top = (size.height - height) / 2.0 // centered vertically
        let shapeRect = CGRect(x:0,
                               y: top,
                               width: size.width,
                               height: height)
        return shapeForCard()
                .path(in: shapeRect)
    }
    
    private func shapeForCard() -> any Shape {
        if card.shape == .shape1 {
            return OvalShape(card.number.rawValue)
        } else if card.shape == .shape2 {
            return DiamondShape(card.number.rawValue)
        } else {
            return SquiggleShape(card.number.rawValue)
        }
    }
}
