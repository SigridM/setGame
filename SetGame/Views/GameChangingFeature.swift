//
//  GameChangingFeature.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/21/22.
//

import SwiftUI

/// A structure for storing information about a given button on the view that includes an image and possibly a bit of text,
/// and when tapped, may initiate an alert before changing in some way a current game already underway such that progress
/// would be lost.
/// With that information stored, this struct can produce a View that shows that information and responds appropriately when
/// tapped, with the correctly worded alert, if needed, and the correct action if the alert is not needed or is dismissed.
 struct GameChangingFeature {
    
    /// the name image to show in the view
    let imageName: String
    
    /// the text to show in the view, if any
    let buttonText: String?
    
    /// a Boolean State which can be unwrapped to find out whether an alert is needed, or its projectedValue Binding can be
    /// used to trigger that alert
    let needsAlert: State<Bool>
    
    /// the function that takes no arguments and returns nothing but is called either if no alert is needed, or if the user
    /// dismisses the alert by indicating that they want to go ahead anyway.
    let continueAction: ()->()
    
    /// The text of the alert message, if one is needed
    let alertMessage: String
    
    /// The game that is being played and who can determine whether we need an alert
    let game: SetGameViewModel
    
    /// Creates and returns a View that will change the current game according to all of the specified features. In a non-alert
    /// situation, it will call its continueAction when tapped. If an alert is needed, it will put up the alert with the appropriate text,
    /// and respond appropriately to that alert.
    /// - Returns: either a VStack or an Image, depending on whether there is button text, along with the embellishments
    /// of tap gesture response, and an alert, if and when appropriate
    func gameChanger() -> some View {
        baseView()
            .alert(
                alertMessage,
                isPresented: needsAlert.projectedValue,
                actions: {alertActionsFor(continueAction)}
            )
            .foregroundColor(.blue)
            .padding(.horizontal)
    }
    
    /// Creates and returns either a combination of image and text (if there is buttonText) or just an image (if there is no
    /// buttonText) which will be further embellished with tapGesture and alert actions
    /// - Returns: either a VStack or an Image, depending on whether there is button text.
    private func baseView() -> some View {
        if let buttonText = buttonText {
            return AnyView(
                Button {
                    needsAlert.wrappedValue = game.hasBegun() && !game.isOver()
                    if !needsAlert.wrappedValue {
                        continueAction()
                    }
                } label: {
                    Label(buttonText, systemImage: imageName)
                }
            )
        } else {
            return AnyView(Image(systemName: imageName))
        }
    }
    
    /// Builds a View that will be used for the Yes and No buttons in the alert, should one be needed on this feature.
    /// - Parameter yesAction: an escaping closure that takes no arguments and returns no value and will be called
    /// if the user indicates that, yes, they want to go ahead anyway, despite the alert.
    /// - Returns: a View built from the component Yes and No buttons by the ViewBuilder
    @ViewBuilder private func alertActionsFor(_ yesAction: @escaping ()-> Void) -> some View {
        Button(role: .destructive) {
            yesAction()
        } label: {
            Text("Yes")
        }
        Button(role: .cancel) { }// do nothing
    label: {
        Text("No")
    }
    }
} // end GameChangingFeature struct
