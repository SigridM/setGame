//
//  CardView.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/20/22.
//

import SwiftUI

/// The view for a single card in a game of Set
struct CardView: View {
    /// The model of a single card
    let card: SetCard
    /// The width calculated for the card by the grid in which it lives
    let width: CGFloat
    
    /// Creates and returns the main view for a single Set Card
    var body: some View {
        let size = CGSize(width: width, height: width / ViewConstants.cardAspectRatio)
        let inset = ViewConstants.inset
        let borderWidth = card.isSelected ? ViewConstants.selectedCardBorderWidth : ViewConstants.cardBorderWidth
        let cornerRadius = size.width / ViewConstants.cornerRadiusFactor
        
        ZStack {
            rectForCard(in: size)
            viewForCard(in: size - inset * 2) // inset is doubled because
                                                       // it is on all sides
                .padding(EdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset))
        }
        .clipShape(
            RoundedRectangle(cornerRadius: cornerRadius)
                .inset(by: borderWidth / 2)
        )
        .opacity(card.isPartOfSet ? ViewConstants.partOfSetOpacity : ViewConstants.notInSetOpacity)
    }
    
    /// Gives the  RoundedRect that makes up the background for a single CardView
    /// - Parameter size: The size that the rect should be
    /// - Returns: a RoundedRectangle surrounding the card
    private func rectForCard(in size: CGSize) -> some View {
        let borderWidth = card.isSelected ? ViewConstants.selectedCardBorderWidth : ViewConstants.cardBorderWidth
        let color = card.isPartOfNonSet ? ViewConstants.partOfNonSetBorderColor : ViewConstants.defaultBorderColor
        
        return RoundedRectangle(cornerRadius: size.width / ViewConstants.cornerRadiusFactor)
            .strokeBorder(style: StrokeStyle(lineWidth: borderWidth))
            .foregroundColor(color)
    }
    
    @ViewBuilder
    /// Gives the View that shows the shapes inside a given card, complete with the right shape, number of shapes, color, and
    /// shading for that card
    /// - Parameter size: The CGSize that circumscribes the view
    /// - Returns: The View that shows the card in this CardView
    private func viewForCard(in size: CGSize) -> some View {
        let shapeRect = calculateShapeRect(in: size)
        
        GeometryReader { _ in
            switch card.shading {
                    // The shaded card is the most complicated: a ZStack containing a pattern on top
                    // of a filled color, both in the shape of the card's symbol
                case .shade1 : // patterned (shaded)
                    let image = ViewConstants.shadingPatternImage
                    ZStack {
                        shapeView(in: shapeRect)
                            .foregroundColor(ViewConstants.cardColors[card.color.rawValue])
                            .opacity(ViewConstants.shadedBottomLayerOpacity)
                        shapeView(in: shapeRect)
                            .foregroundStyle(.image(image))
                            .opacity(ViewConstants.shadedTopLayerOpacity)
                    }
                case.shade2 :  // stroked (outlined)
                    strokedShapeView(in: shapeRect)
                        .foregroundColor(ViewConstants.cardColors[card.color.rawValue])
                case .shade3 : // filled
                    shapeView(in: shapeRect)
                        .foregroundColor(ViewConstants.cardColors[card.color.rawValue])
            }
        }
    }
    
    /// Calculates the rectangle in which the shape should be drawn
    /// - Parameter size: the CGSize that is the size of the card
    /// - Returns: a CGRect for the shape
    private func calculateShapeRect(in size: CGSize) -> CGRect {
        // the height of an individual shape is proportional to the number of shapes on the
        // card vis a vis the maximum number of shapes possible. E.g., if there are two shapes
        // on the card out of three possible shapes, each shape will be 2/3 high
        // A little extra is removed to keep the shape away from the border
        let height = size.height *
        Double(card.number.rawValue) / Double(NumberFeature.allCases.count) -
        ViewConstants.pathAllowance
        
        let top = (size.height - height) / 2.0 // centered vertically
        return CGRect(x:0,
                     y: top,
                     width: size.width,
                     height: height)
    }
    
    /// Creates a view of the shape for this card
    /// - Parameter rect: the CGRect in which to draw the shape
    /// - Returns: a view containing the shape
    @ViewBuilder
    private func shapeView(in rect: CGRect) -> some View {
        // When a card is part of a set, flip the direction to make it "dance"
        let direction = card.isPartOfSet ? -1.0 : 1.0
        
        switch card.shape {
            case .shape1 :
                AnyShape(OvalShape(card.number.rawValue))
                    .scaleEffect(
                        x: card.isPartOfSet ? 0.7 : 1.0,
                        y: card.isPartOfSet ? 1.5 : 1.0,
                        anchor: .center
                    )
                    .animation(
                        card.isPartOfSet ? .easeInOut(duration: 1.0).repeatForever(autoreverses: true) : .default,
                        value: card.isPartOfSet
                    )
                    .frame(width: rect.width, height: rect.height)
                    .position(x: rect.midX, y: rect.midY)
            case .shape2 :
                AnyShape(DiamondShape(card.number.rawValue))
                    .scaleEffect(
                        x: card.isPartOfSet ? 0.7 : 1.0,
                        y: card.isPartOfSet ? 1.5 : 1.0,
                        anchor: .center
                    )
                    .animation(
                        card.isPartOfSet ? .easeInOut(duration: 1.0).repeatForever(autoreverses: true) : .default,
                        value: card.isPartOfSet
                    )
                    .frame(width: rect.width, height: rect.height)
                    .position(x: rect.midX, y: rect.midY)
            case .shape3 :
                AnyShape(SquiggleShape(repetitions: card.number.rawValue, direction: direction))
                    .frame(width: rect.width, height: rect.height)
                    .position(x: rect.midX, y: rect.midY)
                    .animation(
                        card.isPartOfSet ? .easeInOut(duration: 1.0).repeatForever(autoreverses: true) : .default,
                        value: card.isPartOfSet
                    )
        }
    }
    
    /// Creates a stroked view of the shape for this card
    /// - Parameter rect: the CGRect in which to draw the shape
    /// - Returns: a view containing the stroked shape
    @ViewBuilder
    private func strokedShapeView(in rect: CGRect) -> some View {
        // When a card is part of a set, flip the direction to make it "dance"
        let direction = card.isPartOfSet ? -1.0 : 1.0
        
        switch card.shape {
            case .shape1 :
                AnyShape(OvalShape(card.number.rawValue))
                    .stroke(lineWidth: ViewConstants.cardBorderWidth)
                    .scaleEffect(
                        x: card.isPartOfSet ? 0.7 : 1.0,
                        y: card.isPartOfSet ? 1.5 : 1.0,
                        anchor: .center
                    )
                    .animation(
                        card.isPartOfSet ? .easeInOut(duration: 1.0).repeatForever(autoreverses: true) : .default,
                        value: card.isPartOfSet
                    )
                    .frame(width: rect.width, height: rect.height)
                    .position(x: rect.midX, y: rect.midY)
            case .shape2 :
                AnyShape(DiamondShape(card.number.rawValue))
                    .stroke(lineWidth: ViewConstants.cardBorderWidth)
                    .scaleEffect(
                        x: card.isPartOfSet ? 0.7 : 1.0,
                        y: card.isPartOfSet ? 1.5 : 1.0,
                        anchor: .center
                    )
                    .animation(
                        card.isPartOfSet ? .easeInOut(duration: 1.0).repeatForever(autoreverses: true) : .default,
                        value: card.isPartOfSet
                    )
                    .frame(width: rect.width, height: rect.height)
                    .position(x: rect.midX, y: rect.midY)
            case .shape3 :
                AnyShape(SquiggleShape(repetitions: card.number.rawValue, direction: direction))
                    .stroke(lineWidth: ViewConstants.cardBorderWidth)
                    .frame(width: rect.width, height: rect.height)
                    .position(x: rect.midX, y: rect.midY)
                    .animation(
                        card.isPartOfSet ? .easeInOut(duration: 1.0).repeatForever(autoreverses: true) : .default,
                        value: card.isPartOfSet
                    )
        }
    }
}
