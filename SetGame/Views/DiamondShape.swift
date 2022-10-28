//
//  DiamondShape.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 9/26/22.
//

import SwiftUI

/// A Shape that creates a path for a diamond. By default, it draws a single diamond, but can be configured to draw
/// any number of diamonds, stacked vertically, by initializing the shape with a number of repetitions
struct DiamondShape: ClosedRepeatableShape {
    
    /// The total number of diamonds to be drawn, stacked vertically, defaulting to one.
    var repetitions = 1
    
    /// The points that make up the endpoints of a diamond, represented as fractions of a unit so they can be scaled to the
    /// enclosing rectangle
    let pointFactors = DiamondConstants.pointFactors

    /// A struct to encapsulate the constants for the Diamond drawing
    struct DiamondConstants {
        
        /// points 0 and 2 are both in the center of the rect, half of the width
        private static let point0XFactor = 1.0 / 2.0
        private static let point2XFactor = 1.0 / 2.0
        
        /// points 1 and 3 are at the edges of the rect: all (100%) and none (0%) of the width, respectively
        private static let point1XFactor = 1.0
        private static let point3XFactor = 0.0
        
        /// points 1 and 3 are both in the middle of the rect, half the height.
        private static let point1YFactor = 1.0 / 2.0
        private static let point3YFactor = 1.0 / 2.0
        
        /// points 0 and 2 are a tiny bit away from the bottom and top, respectively, just so they aren't joined.
        private static let defaultHeight = 80.0
        private static let secondPointYInset = 1.0
        private static let point0YFactor = secondPointYInset / defaultHeight
        private static let point2YFactor = (defaultHeight - secondPointYInset) / defaultHeight
        
        /// An Array of the four points delineating the four segments of the diamond
        static var pointFactors = [
            CGPoint(x: point0XFactor, y: point0YFactor),
            CGPoint(x: point1XFactor, y: point1YFactor),
            CGPoint(x: point2XFactor, y: point2YFactor),
            CGPoint(x: point3XFactor, y: point3YFactor)
        ]
                   
    }
    
}

/// Tests the DiamondShape by drawing each of three sets of diamonds: a DiamondShape with one diamond; a DiamondShape with
/// two diamonds, and a DiamondShape with three diamonds. Because all diamonds should be the same size, regardless of the number,
/// the first is drawn in a rectangle one third the height of the last, and the second in a rectangle 2/3 the height of the last, with each one
/// centererd vertically.  Additional rects and dots are drawn for debugging purposes, if debuggingn is true
struct DiamondView: View {
    let debugging = true
    let color: Color = .blue
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    let wholeRect = CGRect(x:0,
                                       y: 0,
                                       width: geometry.size.width,
                                       height: geometry.size.height)
                    
                    // so that the diamonds in all three rects remain the same size,
                    // make this one, with only one diamond, one third the height of the
                    // whole rect, and center it one third of the way down the rect
                    let diamondRect = CGRect(x:0,
                                      y: 0 + wholeRect.height/3,
                                      width: wholeRect.width,
                                      height: wholeRect.height/3)

                    DiamondShape()
                        .path(in: diamondRect)
                        .strokedPath(StrokeStyle(lineWidth: 3.0))
                        .foregroundColor(color)
                    
                    if debugging {
                        Rectangle()
                            .path(in: wholeRect)
                            .strokedPath(StrokeStyle(lineWidth: 3.0))
                        Rectangle()
                            .path(in: diamondRect)
                            .opacity(0.1)
                        DiamondShape()
                            .debugViews(in: diamondRect, with: [.red, .purple, .green, .blue])
                    }
                    Spacer()
                }
            }
            GeometryReader {geometry in
                ZStack {

                    let wholeRect = CGRect(x:0,
                                       y: 0,
                                       width: geometry.size.width,
                                       height: geometry.size.height)
                    
                    // so that the diamonds in all three rects remain the same size,
                    // make this one, with only two diamonds, two thirds the height of the
                    // whole rect, and center it one sixth of the way down the rect
                    let diamondRect = CGRect(x:0,
                                       y: 0 + wholeRect.height/6,
                                       width: wholeRect.width,
                                       height: wholeRect.height*2/3)
                    DiamondShape(2)
                        .path(in: diamondRect)
                        .foregroundColor(color)

                    if debugging {
                        Rectangle()
                            .path(in: wholeRect)
                            .strokedPath(StrokeStyle(lineWidth: 3.0))
                        Rectangle()
                            .path(in: diamondRect)
                            .opacity(0.1)
                        DiamondShape(2)
                            .debugViews(in: diamondRect, with: [.orange, .purple, .teal, .cyan])
                    }
                    Spacer()
                }
            }
            GeometryReader {geometry3 in
                ZStack {
                    let diamondRect = CGRect(x:0,
                                      y: 0,
                                      width: geometry3.size.width,
                                      height: geometry3.size.height)
                    let image = Image(systemName: "circle.grid.3x3")
                    DiamondShape(3)
                        .path(in: diamondRect)
                        .foregroundColor(color)
                        .opacity(0.65)
                    DiamondShape(3)
                        .path(in: diamondRect)
                        .foregroundStyle(.image(image))
                        .opacity(0.55)
                    
                    if debugging {
                        Rectangle()
                            .path(in: diamondRect)
                            .strokedPath(StrokeStyle(lineWidth: 3.0))
                        Rectangle()
                            .path(in: diamondRect)
                            .opacity(0.1)
                        DiamondShape(3)
                            .debugViews(in: diamondRect, with: [.red, .purple, .green, .blue])
                        .opacity(0.75)
                    }
                    Spacer()
                }
            }
        }
        .padding()
    }
}

struct DiamondShape_Previews: PreviewProvider {
    static var previews: some View {
        DiamondView()
    }
}
