//
//  SquiggleShape.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 9/26/22.
//

import SwiftUI

/// A Shape that creates a path for a diamond. By default, it draws a single diamond, but can be configured to draw
/// any number of diamonds, stacked vertically, by initializing the shape with a number of repetitions
struct DiamondShape: Shape {
    /// The total number of diamonds to be drawn, stacked vertically, defaulting to one.
    let repetitions: Int
    
    /// Initialize the DiamondShape to have the default single diamond
    init() {
        self.repetitions = 1
    }
    
    /// Initialize the DiamondShape to have any number of repetitions of the diamond, stacked vertically
    /// - Parameter repetions: the number of repetitions of the diamond
    init(_ repetitions: Int) {
        guard repetitions > 0 else {
            self.repetitions = 1
            return
        }
        self.repetitions = repetitions
    }
    
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
        static let pointFactors = [
            CGPoint(x: point0XFactor, y: point0YFactor),
            CGPoint(x: point1XFactor, y: point1YFactor),
            CGPoint(x: point2XFactor, y: point2YFactor),
            CGPoint(x: point3XFactor, y: point3YFactor)
        ]
                   
        /// For debugging, the radius of the circle that shows where a point is that defines the end of a segment
        static let defaultPointRadius = 4.0
    }
    
    
    /// Creates and returns an array of the four CGPoints delimiting the four lines of the diamond, scaled to
    /// the given CGSize
    /// - Parameter size: a CGSize into which the diamond should fit.
    /// - Returns: an Array of four CGPoints
    private func pointsScaled(to size: CGSize) -> [CGPoint] {
        let scaling = CGAffineTransform(scaleX: size.width, y: size.height)
        return DiamondConstants.pointFactors.map{$0.applying(scaling)}
    }
    
    /// Adds a single diamond to the given path
    /// - Parameters:
    ///   - path: the Path that will be modified to include the new diamond
    ///   - points: the end points delimiting the four lines of the diamond
    private func addDiamondTo(_ path: inout Path, using points: [CGPoint]) {
        path.move(to: points[0])
        
        for pointIndex in points.indices {
            path.addLine(to: points[(pointIndex + 1) % points.count])
        }
    }

    /// Creates and returns a Path that draws a number of diamonds, stacked vertically, the number of which is specified by
    /// the receiver's repetitions instance variable.
    /// - Parameter rect: a CGRect circumscribing all the diamonds
    /// - Returns: a Path that draws the diamonds
    private func diamonds(in rect: CGRect) -> Path {
        var points = pointsScaled(to: rect.size)
        
        // to fit all the repetitions into the space, we must divide the space up, vertically,
        // by the number of repetitions
        let divisor = Double(repetitions)
        
        let scale = CGSize(width: 1.0, height: 1.0/divisor)
        points = points.map{$0.scaled(to: scale)}
        
        // once you have the scaled points, move them to the top of the CGRect
        points = points.map{$0.moved(by: rect.origin)}
        
        let shift = CGPoint(x: 0.0, y: rect.height/divisor) // how far down to shift each rep
        
        var path = Path()
        
        var iteration = 1
        
        repeat {
            addDiamondTo(&path, using: points)
            points = points.map{$0.moved(by: shift)}
            iteration += 1
        } while iteration <= repetitions
        
        return path
    }
    
    /// For debugging purposes, create and return a path that draws a circle for each line of each diamond in the receiver:
    /// the point is the point at the beginning of a line. This is repeated for each diamond in the receiver, scaled and shifted
    /// appropriately.
    /// - Parameters:
    ///   - rect: a CGRect circumscribing the entire DiamondShape
    ///   - originIndex: the index of the point starting the segment
    /// - Returns: a Path that draws all the circles
    private func dotsPath(in rect: CGRect, from originIndex: Int) -> Path {
        
        var point = pointsScaled(to: rect.size)[originIndex]
        let divisor = Double(repetitions)
        
        let scale = CGSize(width: 1.0, height: 1.0/divisor)
        point = point.scaled(to: scale)
        
        // once you have the scaled points, move them to the top of the CGRect
        point = point.moved(by: rect.origin)
        
        let shift = CGPoint(x: 0.0, y: rect.height/divisor)

        var path = Path()
        var iteration = 1

        repeat {
            addCircle(to: &path, using: point)
            point = point.moved(by: shift)
            iteration += 1
        } while iteration <= repetitions
        
        return path
    }
    
    /// For debugging purposes, add the circles to the given path that show the point at the beginning of a line as well
    /// as the two control points for that segment
    /// - Parameters:
    ///   - path: the Path that will be modified by adding a circle to it
    ///   - point: the CGPoint at the beginning of the line
    private func addCircle(to path: inout Path, using point: CGPoint) {
        let radius = DiamondConstants.defaultPointRadius
        
        // Move to and draw a larger circle at the beginning point
        path.move(to: point)
        path.addArc(center: point,
                    radius: radius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        
    }
    
    /// For debugging purposes, creates and returns a ZStack of Views, each of which contains a path for a DiamondShape of one of
    /// the given colors, where the path can show the beginning point that begins each of the diamond's lines
    /// - Parameters:
    ///   - rect: the CGRect that circumscribes the entire DiamondShape
    ///   - colors: an Array of Colors, one for each of the four segments of the Squiggle
    /// - Returns: a composite View of all of the SquiggleShapes, with their dot paths, stacked on top of each other.
    @ViewBuilder
    func debugViews(in rect: CGRect, with colors: [Color]) -> some View {
        ZStack {
            ForEach(0..<4) { index in
                DiamondShape(repetitions)
                    .dotsPath(in: rect, from: index)
                    .foregroundColor(colors[index])
                    .opacity(0.75)
            }
        }
    }
    
    /// To conform to the Shape protocol, creates and returns the Path that draws the shape.
    /// - Parameter rect: a CGRect that circumscribes the diamond
    /// - Returns: a Path that draws the diamond
    func path(in rect: CGRect) -> Path {
        return diamonds(in: rect)
    }
}

/// Tests the DiamondShape by drawing each of three sets of diamonds: a DiamondShape with one diamond; a DiamondShape with
/// two diamonds, and a DiamondShape with three diamonds. Because all diamonds should be the same size, regardless of the number,
/// the first is drawn in a rectangle one third the height of the last, and the second in a rectangle 2/3 the height of the last, with each one
/// centererd vertically.  Additional rects and dots are drawn for debugging purposes, if debuggingn is true
struct DiamondView: View {
    let debugging = false
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
