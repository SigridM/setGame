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
            let testCard = SetCard(shape: ShapeFeature.shape3, shading: ShadeFeature.shade2, color: ColorFeature.color3, number: NumberFeature.three)
            CardView(card: testCard)
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
    let colors: [Color] = [.red, .green, .blue]
    
    
    var body: some View {
         GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(style: StrokeStyle(lineWidth: 2))
                shapeForCard(in: geometry.size)
            }
        }
    }
    
    @ViewBuilder
    private func shapeForCard(in size: CGSize) -> some View {
        if card.shading == .shade1 {
            pathForCard(in: size)
                .strokedPath(StrokeStyle(lineWidth: 3.0))
                .foregroundColor(colors[card.color.rawValue - 1])
        } else if card.shading == .shade2 {
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
        } else {
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
        if card.shape == .shape1 {
            return OvalShape(card.number.rawValue)
                .path(in: shapeRect)
        } else if card.shape == .shape2 {
            return DiamondShape(card.number.rawValue)
                .path(in: shapeRect)
        } else {
            return SquiggleShape(card.number.rawValue)
                .path(in: shapeRect)
        }
    }
}
