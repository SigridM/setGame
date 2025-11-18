//
//  DiamondView.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 12/7/22.
//

import SwiftUI

/// Tests the DiamondShape by drawing each of three sets of diamonds: a DiamondShape with one diamond; a DiamondShape with
/// two diamonds, and a DiamondShape with three diamonds. Because all diamonds should be the same size, regardless of the number,
/// the first is drawn in a rectangle one third the height of the last, and the second in a rectangle 2/3 the height of the last, with each one
/// centererd vertically.  Additional rects and dots are drawn for debugging purposes, if debuggingn is true
struct DiamondView: View {
    let debugging = true
    let color: Color = .red
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
                    
                    DiamondShape2()
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
                    DiamondShape2(2)
                        .path(in: diamondRect)
//                        .strokedPath(StrokeStyle(lineWidth: 3.0))
//                        .fill(color)
                        .foregroundColor(color)
                        .frame(width: diamondRect.width, height: diamondRect.height, alignment: .center)

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

