//
//  CardView.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/20/22.
//

import SwiftUI

/// The view for a single card in a game of Set
struct CardView: View {
    let card: SetCard
    private let colors: [Color] = [.red, .green, .blue]
    
    var body: some View {
        GeometryReader { geometry in
            let answer = ZStack {
                let inset = ViewConstants.inset
                rectForCard(in: geometry.size)
                viewForCard(in: geometry.size - inset * 2) // inset is doubled because
                                                           // it is on all sides
                    .padding(EdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset))
            }
            if card.isPartOfSet {
                answer.opacity(ViewConstants.partOfSetOpacity)
            } else {
                answer.opacity(ViewConstants.notInSetOpacity)
            }
            
        }
    }
    
    /// Gives the  RoundedRect that makes up the background for a single CardView
    /// - Parameter size: The size that the rect should be
    /// - Returns: a RoundedRectangle surrounding the card
    private func rectForCard(in size: CGSize) -> some View {
        var borderWidth: Double
        var color: Color
        if card.isSelected {
            borderWidth = ViewConstants.selectedCardBorderWidth
        } else {
            borderWidth = ViewConstants.cardBorderWidth
        }
        if card.isPartOfNonSet {
            color = ViewConstants.partOfNonSetBorderColor
        } else {
            color = ViewConstants.defaultBorderColor
        }
        let rect = RoundedRectangle(cornerRadius: size.width / ViewConstants.cornerRadiusFactor)
            .strokeBorder(style: StrokeStyle(lineWidth: borderWidth))
            .foregroundColor(color)
        return rect
    }
    
    @ViewBuilder
    /// Gives the View that shows the shapes inside a given card, complete with the right shape, number of shapes, color, and
    /// shading for that card
    /// - Parameter size: The CGSize that circumscribes the view
    /// - Returns: The View that shows the card in this CardView
    private func viewForCard(in size: CGSize) -> some View {
        
        switch card.shading {
                // The shaded card is the most complicated: a ZStack containing a pattern on top
                // of a filled color, both in the shape of the card's symbol
            case .shade1 : // patterned (shaded)
                let image = ViewConstants.shadingPatternImage
                let bottomView = pathForCard(in: size)
                    .foregroundColor(colors[card.color.rawValue])
                    .opacity(ViewConstants.shadedBottomLayerOpacity)
                let topView = pathForCard(in: size)
                    .foregroundStyle(.image(image))
                    .opacity(ViewConstants.shadedTopLayerOpacity)
                ZStack {
                    bottomView
                    topView
                }
            case.shade2 :  // stroked (outlined)
                pathForCard(in: size)
                    .strokedPath(StrokeStyle(lineWidth: ViewConstants.cardBorderWidth))
                    .foregroundColor(colors[card.color.rawValue])
            case .shade3 : // filled
                pathForCard(in: size)
                    .foregroundColor(colors[card.color.rawValue])
        }
        
    }
    
    /// Answers a Path that draws the shape(s) for the CardView's card
    /// - Parameter size: the CGSize that is the size of the card; the size and position of the shape inside this size
    /// will depend on the number of shapes on the card
    /// - Returns: a Path that draws the shape(s) on the card
    private func pathForCard(in size: CGSize) -> Path {
        
        // the height of an individual shape is proportional to the number of shapes on the
        // card vis a vis the maximum number of shapes possible. E.g., if there are two shapes
        // on the card out of three possible shapes, each shape will be 2/3 high
        // A little extra is removed to keep the shape away from the border
        let height = size.height *
        Double(card.number.rawValue) / Double(NumberFeature.allCases.count) -
        ViewConstants.pathAllowance
        
        let top = (size.height - height) / 2.0 // centered vertically
        let shapeRect = CGRect(x:0,
                               y: top,
                               width: size.width,
                               height: height)
        return shapeForCard()
            .path(in: shapeRect)
    }
    
    /// Answers the Shape that will be drawn on the card for the CardView. The shape can be drawn any number of times within
    /// its rectangle, so we pass that number into the shape so it can know how many iterations of itself to draw when it returns
    /// its path
    /// - Returns: either an OvalShape, a DiamondShape, or a SquiggleShape, depending on the shape of the card
    private func shapeForCard() -> any Shape {
        switch card.shape {
            case .shape1 :
                return OvalShape(card.number.rawValue)
            case .shape2 :
                return DiamondShape(card.number.rawValue)
            case .shape3 :
                return SquiggleShape(card.number.rawValue)
        }
        
    }
}
