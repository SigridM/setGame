//
//  ViewConstants.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/6/22.
//

import Foundation
import SwiftUI
/// Encapsulates all of the constants used in the view into one struct
struct ViewConstants {
    
    /// How wide the width of the border around each card should be
    static let cardBorderWidth = 3.0
    
    /// How wide the width of the border around each card should be
    static let selectedCardBorderWidth = cardBorderWidth * 2
    
    /// The shape of the cards, width relative to height
    static let cardAspectRatio = 2.0/3.0
    
    /// Each card should be no smaller than this width, even if there are several on the table. If they won't fit at this width, the
    /// view should scroll
    static let minCardWidth = 55.0
    
    /// The opacity that a card should have to indicate it is part of a proper set
    static let partOfSetOpacity = 0.25
    
    /// The opacity that a card should have when it is not part of a proper set
    static let notInSetOpacity = 1.0
    
    /// The opacity that makes up the bottom, colored layer when a shape is shaded
    static let shadedBottomLayerOpacity = 0.65
    
    /// The opacity that makes up the top, patterned layer when a shape is shaded
    static let shadedTopLayerOpacity = 0.55
    
    /// The image that is used to make the pattern for a shaded shape
    static let shadingPatternImage = Image(systemName: "circle.grid.3x3")
    
    /// The little bit shaved off the height of a shape to keep it well within the border of its rectangle inside a card
    static let pathAllowance = 2.0

    /// The color of the border of a card that indicates that the user chose the maximum number of cards, but they don't make up a
    /// proper set, used only for those cards that are part of the non-set
    static let partOfNonSetBorderColor = Color.black
    
    /// The color of the border of a card by default.
    static let defaultBorderColor = Color.gray
    
    /// The String that is the common part of the alert message
    static let alertMessageBase = "Game is not over. Are you sure you want "
    /// The String message to show if we need to pop up an alert dialog on reset
    static let resetAlertMessage = alertMessageBase + "to reset?"
    /// The String message to show if we need to pop up an alert dialog on new game
    static let newGameAlertMessage = alertMessageBase + "a new game?"
    /// The String message to show if we need to pop up an alert dialog when decreasing the cards
    static let removeCardsAlertMessage = alertMessageBase + "a new game with fewer cards?"
    /// The String message to show if we need to pop up an alert dialog when decreasing the cards
    static let addCardsAlertMessage = alertMessageBase + "a new game with more cards?"
    
    /// The following three images are the system images for the given buttons
    static let addImageName = "plus.circle"
    static let addImage = Image(systemName: addImageName)
    static let newGameImageName = "play.square"
    static let newGameImage = Image(systemName: newGameImageName)
    static let hintImageName = "questionmark.circle"
    static let hintImage = Image(systemName: hintImageName)

    /// A Double, the denominator for the fraction of the width of a single card that should serve as the radius
    /// of the circle creating the rounded corner of a card
    static let cornerRadiusFactor = 4.0
    
    /// A Double that reduces the size of a shape relative to the size of the rect it is in for a single card
    static let inset = 12.0
    
    /// The three different colors that cards can be
    static let cardColors = [Color.red, Color.green, Color.blue]
    
    /// For flashing a hint to the user for a set that is on the table, the number of seconds to show the set selection
    static let delayTime = 1.0
    
    /// For flashing a hint to the user for a cap set, the number of seconds to blink the card adder
    static let quickDelayTime = 0.5
} // end ViewConstants
