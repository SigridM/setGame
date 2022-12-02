//
//  OvalShape.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 9/26/22.
//

import SwiftUI

/// A Shape that creates a path for an oval. By default, it draws a single oval, but can be configured to draw
/// any number of ovals, stacked vertically, by initializing the shape with a number of repetitions
struct OvalShape: CurvedClosedRepeatableShape {
    
    var repetitions = 1
    var pointFactors = OvalConstants.pointFactors
    var controlFactors = OvalConstants.controlFactors
    typealias SegmentKey = FourPartSegmentName

} // end OvalShape

/// Tests the OvalShape by drawing each of three sets of ovals: a OvalShape with one oval; a OvalShape with
/// two ovals, and a OvalShape with three ovals. Because all ovals should be the same size, regardless of the number,
/// the first is drawn in a rectangle one third the height of the last, and the second in a rectangle 2/3 the height of the last, with each one
/// centererd vertically.  Additional rects and dots are drawn for debugging purposes, if debuggingn is true
struct OvalView: View {
    let debugging = true
    let color: Color = .green
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    let wholeRect = CGRect(x:0,
                                       y: 0,
                                       width: geometry.size.width,
                                       height: geometry.size.height)
                    
                    // so that the ovals in all three rects remain the same size,
                    // make this one, with only one oval, one third the height of the
                    // whole rect, and center it one third of the way down the rect
                    let ovalRect = CGRect(x:0,
                                      y: 0 + wholeRect.height/3,
                                      width: wholeRect.width,
                                      height: wholeRect.height/3)

                    OvalShape()
                        .path(in: ovalRect)
                        .strokedPath(StrokeStyle(lineWidth: 3.0))
                        .foregroundColor(color)
                    
                    if debugging {
                        Rectangle()
                            .path(in: wholeRect)
                            .strokedPath(StrokeStyle(lineWidth: 3.0))
                        Rectangle()
                            .path(in: ovalRect)
                            .opacity(0.1)
                        OvalShape()
                            .debugViews(in: ovalRect, with: [.red, .purple, .green, .blue])
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

                    // so that the ovals in all three rects remain the same size,
                    // make this one, with only two ovals, two thirds the height of the
                    // whole rect, and center it one sixth of the way down the rect
                    let ovalRect = CGRect(x:0,
                                       y: 0 + wholeRect.height/6,
                                       width: wholeRect.width,
                                       height: wholeRect.height*2/3)
                    OvalShape(2)
                        .path(in: ovalRect)
                        .foregroundColor(color)

                    if debugging {
                        Rectangle()
                            .path(in: wholeRect)
                            .strokedPath(StrokeStyle(lineWidth: 3.0))
                        Rectangle()
                            .path(in: ovalRect)
                            .opacity(0.1)
                        OvalShape(2)
                            .debugViews(in: ovalRect, with: [.orange, .purple, .teal, .cyan])
                    }
                    Spacer()
                }
            }
            GeometryReader {geometry3 in
                ZStack {
                    let ovalRect = CGRect(x:0,
                                      y: 0,
                                      width: geometry3.size.width,
                                      height: geometry3.size.height)
                    let image = Image(systemName: "circle.grid.3x3")
                    OvalShape(3)
                        .path(in: ovalRect)
                        .foregroundColor(color)
                        .opacity(0.65)
                    OvalShape(3)
                        .path(in: ovalRect)
                        .foregroundStyle(.image(image))
                        .opacity(0.55)

                    if debugging {
                        Rectangle()
                            .path(in: ovalRect)
                            .strokedPath(StrokeStyle(lineWidth: 3.0))
                        Rectangle()
                            .path(in: ovalRect)
                            .opacity(0.1)
                        OvalShape(3)
                            .debugViews(in: ovalRect, with: [.red, .purple, .green, .blue])
                        .opacity(0.75)
                    }
                    Spacer()
                }
            }
        }
        .padding()
    } // end body
} // end OvalView

struct OvalShape_Previews: PreviewProvider {
    static var previews: some View {
        OvalView()
    }
}
