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
    
    /// The shape of the cards, width relative to height
    static let cardAspectRatio = 2.0/3.0
    
    /// The value of the opacity of a card when it has been turned down and is matched; 0 == fully transparent; 1 == fully opaque;
    /// when cards are matched, make them transparent so they disappear from view
    static let downAndMatchedOpacity = 0.0
    
    /// The value of the opacity of a card when it has been turned up and is unmatched; 0 == fully transparent; 1 == fully opaque;
    /// when cards are up and unmatched, make them fully opaque.
    static let upAndUnmatchedOpacity = 0.0
    
    /// The value of the opacity of a card when it is turned up but was just matched; dim it distinguish between it and an unmatched
    /// card
    static let upAndMatchedOpacity = 0.1
    
    /// A Boolean, true if we are currently printing a lot of diagnostics about the card width calculations to the console
    static let debuggingCardWidth = false
    
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
    
    /// The following four images are the system images for the given buttons
    static let addImage = Image(systemName: "plus.circle")
    static let removeImage = Image(systemName: "minus.circle")
    static let resetImage = Image(systemName: "arrow.uturn.forward.circle")
    static let newGameImage = Image(systemName: "play.square")
    
    /// A Double, the denominator for the fraction of the width of a single card that should serve as the radius
    /// of the circle creating the rounded corner of a card
    static let cornerRadiusFactor = 4.0
    
    /// A Double that relates the size of the text emoji to the size of a card
    static let emojiScale = 0.8
} // end ViewConstants
