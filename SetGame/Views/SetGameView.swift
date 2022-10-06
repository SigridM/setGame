//
//  SetGameView.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 9/26/22.
//

import SwiftUI

struct SetGameView: View {
    var body: some View {
        VStack {
//            let testCard = SetCard(shape: ShapeFeature.shape1,
//                                   shading: ShadeFeature.shade1,
//                                   color: ColorFeature.color1,
//                                   number: NumberFeature.one)
//            let testCard2 = SetCard(shape: ShapeFeature.shape2,
//                                   shading: ShadeFeature.shade2,
//                                   color: ColorFeature.color2,
//                                   number: NumberFeature.two)
//            let testCard3 = SetCard(shape: ShapeFeature.shape3,
//                                    shading: ShadeFeature.shade3,
//                                    color: ColorFeature.color3,
//                                    number: NumberFeature.three)
//            CardView(card: testCard)
//            CardView(card: testCard2)
//            CardView(card: testCard3)
            
//            ForEach(SetDeck<SetCard>.newVeryLimitedDeck().cards) { card in
//                CardView(card: card)
//            }
            var deck = SetDeck<SetCard>.newLimitedDeck()
            let cards = deck.initialDeal()
            AspectVGrid(items: cards, aspectRatio: 2.0/3.0) { card, something in
                CardView(card: card)
            }

        }
        .padding()
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
            ZStack {
                let inset = 12.0
                RoundedRectangle(cornerRadius: inset)
                    .stroke(style: StrokeStyle(lineWidth: 3))
                    .foregroundColor(colors[card.color.rawValue - 1])
                viewForCard(in: geometry.size - inset * 2)
                    .padding(EdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset))
            }
        }
    }
    
    @ViewBuilder
    private func viewForCard(in size: CGSize) -> some View {
        
        switch card.shading {
            case .shade1 : // patterned (shaded)
                let image = Image(systemName: "circle.grid.3x3")
                let bottomView = pathForCard(in: size)
                    .foregroundColor(colors[card.color.rawValue - 1])
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
                    .foregroundColor(colors[card.color.rawValue - 1])
            case .shade3 : // filled
                pathForCard(in: size)
                    .foregroundColor(colors[card.color.rawValue - 1])
        }

    }
    
    private func pathForCard(in size: CGSize) -> Path {
        let height = size.height * Double(card.number.rawValue) / Double(NumberFeature.allCases.count)
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
