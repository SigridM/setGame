//
//  SquiggleShape.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 9/26/22.
//

import SwiftUI

/// A Shape that creates a path for a worm-like curve. By default, it draws a single squiggle, but can be configured to draw
/// any number of squiggles, stacked vertically, by initializing the shape with a number of repetitions
struct SquiggleShape: CurvedClosedRepeatableShape {
    init() {
    }
    
    /// The total number of squiggles to be drawn, stacked vertically, defaulting to one.
    var repetitions = 1
    var pointFactors = SquiggleConstants.downLeftPointFactors
    var controlFactors = SquiggleConstants.downLeftControlFactors
    typealias SegmentKey = FourPartSegmentName
    
    var direction: Double {
        get {
            if pointFactors == SquiggleConstants.downLeftPointFactors {
                return 1.0
            } else {
                return -1.0
            }
        }
        set {
            if newValue == 1.0 {
                pointFactors = SquiggleConstants.downLeftPointFactors
                controlFactors = SquiggleConstants.downLeftControlFactors
            } else {
                pointFactors = SquiggleConstants.upLeftPointFactors
                controlFactors = SquiggleConstants.upLeftControlFactors
            }
        }
    }
    
    init(repetitions: Int = 1, pointFactors: [CGPoint] = SquiggleConstants.downLeftPointFactors, controlFactors: [FourPartSegmentName : SegmentController] = SquiggleConstants.downLeftControlFactors, direction: Double = 1.0) {
        self.repetitions = repetitions
        self.pointFactors = pointFactors
        self.controlFactors = controlFactors
        self.direction = direction
    }
    

    /// For debugging purposes, creates and returns a ZStack of Views, each of which contains a path for a OvalShape of one of
    /// the given colors, where the path can show the points and control points that make up the oval's curves
    /// - Parameters:
    ///   - rect: the CGRect that circumscribes the entire OvalShape
    ///   - colors: an Array of Colors, one for each of the four segments of the Oval
    /// - Returns: a composite View of all of the OvalShapes, with their dot paths, stacked on top of each other.
    @ViewBuilder
    func debugViews(in rect: CGRect, with colors: [Color]) -> some View {
        ZStack {
            ForEach(0..<colors.count, id: \.self) { index in
                Self(repetitions: repetitions, direction: self.direction)
                    .dotsPath(in: rect, from: index)
                    .foregroundColor(colors[index])
                    .opacity(0.75)
            }
        }
    }
   
} // end SquiggleShape


/// Tests the SquiggleShape by drawing each of three sets of squiggles: a SquiggleShape with one squiggle; a SquiggleShape with
/// two squiggles, and a SquiggleShape with three squiggles. Because all squiggles should be the same size, regardless of the number,
/// the first is drawn in a rectangle one third the height of the last, and the second in a rectangle 2/3 the height of the last, with each one
/// centererd vertically.  Additional rects and dots are drawn for debugging purposes, if debuggingn is true
struct SquiggleView: View {
    let debugging = true
    let color: Color = .blue
    @State private var squiggleDirection = 1.0
    @State private var animating = false
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    let wholeRect = CGRect(x:0,
                                           y: 0,
                                           width: geometry.size.width,
                                           height: geometry.size.height)
                    
                    // so that the squiggles in all three rects remain the same size,
                    // make this one, with only one squiggle, one third the height of the
                    // whole rect, and center it one third of the way down the rect
                    let squiggleRect = CGRect(x:0,
                                              y: 0 + wholeRect.height/3,
                                              width: wholeRect.width,
                                              height: wholeRect.height/3)
                    Group {
                        if animating {
                            SquiggleShape(
                                repetitions: 1,
                                direction: squiggleDirection * -1.0
                            )
                            .stroke(style: StrokeStyle.init(lineWidth: 3.0))
                            .frame(width: squiggleRect.width, height: squiggleRect.height, alignment: .center)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 0.5).repeatForever()) {
                                    squiggleDirection *= -1.0
                                }
                            }
                            .transition(.identity) // keeps it from changing opacity

                        } else {
                            SquiggleShape(
                                repetitions: 1,
                                direction: squiggleDirection * -1.0
                            )
                            .stroke(style: StrokeStyle.init(lineWidth: 3.0))
                            .frame(width: squiggleRect.width, height: squiggleRect.height, alignment: .center)
                        }
                    }
                    .foregroundColor(color)
                    
                    if debugging {
                        Group {
//                            if animating {
                            let halfRect = CGRect(origin: squiggleRect.origin,
                                                  size: CGSize(width: squiggleRect.width / 2,
                                                               height: squiggleRect.height)
                                                  )
                                Rectangle()
                                    .path(in: wholeRect)
                                    .strokedPath(StrokeStyle(lineWidth: 3.0))
                                Rectangle()
                                    .path(in: squiggleRect)
                                    .opacity(0.1)
                                Rectangle()
                                .path(in: halfRect)
                                    .opacity(0.1)
                                SquiggleShape(
                                    repetitions: 1,
                                    direction: squiggleDirection * -1.0
                                )
                                .debugViews(in: squiggleRect, with: [.orange, .purple, .teal, .cyan])
//                            }
                        }
                        .transition(.identity)
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
                    
                    // so that the squiggles in all three rects remain the same size,
                    // make this one, with only two squiggles, two thirds the height of the
                    // whole rect, and center it one sixth of the way down the rect
                    let squiggleRect = CGRect(x:0,
                                              y: 0 + wholeRect.height/3,
                                              width: wholeRect.width,
                                              height: wholeRect.height/3)
                    
                    Group {
                        if animating {
                            SquiggleShape(
                                repetitions: 1,
                                direction: squiggleDirection
                            )
                            .frame(width: squiggleRect.width, height: squiggleRect.height, alignment: .center)
                            .transition(.identity)
                            
                        } else {
                            SquiggleShape(
                                repetitions: 1,
                                direction: squiggleDirection
                            )
                            .frame(width: squiggleRect.width, height: squiggleRect.height, alignment: .center)
                        }
                    }
                    .foregroundColor(color)
                    
                    if debugging {
                        Rectangle()
                            .path(in: wholeRect)
                            .strokedPath(StrokeStyle(lineWidth: 3.0))
                        Rectangle()
                            .path(in: squiggleRect)
                            .opacity(0.1)
                        SquiggleShape(1)
                            .debugViews(in: squiggleRect, with: [.orange, .purple, .teal, .cyan])
                    }
                    Spacer()
                }
            }
            GeometryReader {geometry3 in
                ZStack {
                    let squiggleRect = CGRect(x:0,
                                              y: 0,
                                              width: geometry3.size.width,
                                              height: geometry3.size.height)
                    let image = Image(systemName: "circle.grid.3x3")
                    Group {
                        if animating {
                            SquiggleShape(
                                repetitions: 3,
                                direction: squiggleDirection
                            )
                            .frame(width: squiggleRect.width, height: squiggleRect.height, alignment: .center)
                            .foregroundStyle(.image(image))
                            .opacity(0.55)

                            SquiggleShape(
                                repetitions: 3,
                                direction: squiggleDirection
                            )
                            .frame(width: squiggleRect.width, height: squiggleRect.height, alignment: .center)
                            .foregroundColor(color)
                            .opacity(0.65)
                        } else {
                            
                            SquiggleShape(repetitions: 3, direction: squiggleDirection)
                                .frame(width: squiggleRect.width, height: squiggleRect.height, alignment: .center)
                                .foregroundColor(color)
                                .opacity(0.65)
                            SquiggleShape(repetitions: 3, direction: squiggleDirection)
                                .frame(width: squiggleRect.width, height: squiggleRect.height, alignment: .center)
                                .foregroundStyle(.image(image))
                                .opacity(0.55)
                        }
                    }
                    .transition(.identity) // keeps it from fading
                    
                    if debugging {
                        Rectangle()
                            .path(in: squiggleRect)
                            .strokedPath(StrokeStyle(lineWidth: 3.0))
                        Rectangle()
                            .path(in: squiggleRect)
                            .opacity(0.1)
                        SquiggleShape(repetitions: 3, direction: squiggleDirection)
                            .debugViews(in: squiggleRect, with: [.red, .purple, .green, .blue])
                            .opacity(0.75)
                    }
                    Spacer()
                }
            }

            Button("Toggle Animation") {
                animating.toggle()
            }
        } // end VStack
//        .onAppear {
//            moving.toggle()
//        }
        .padding()
    } // end body
} // end SquiggleView

struct SquiggleShape_Previews: PreviewProvider {
    static var previews: some View {
        SquiggleView()
    }
}
