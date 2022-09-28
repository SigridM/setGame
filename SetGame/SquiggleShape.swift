//
//  SquiggleShape.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 9/26/22.
//

import SwiftUI

struct SquiggleShape: Shape {
    func createExampleBezierPath() -> Path {
        // create a new path
        var path = Path()
        // starting point for the path (bottom left)
        path.move(to: CGPoint(x: 2, y: 26))
        // *********************
        // ***** Left side *****
        // *********************
        // segment 1: line
        path.addLine(to: CGPoint(x: 2, y: 15))
        // segment 2: curve
        path.addCurve(to: CGPoint(x: 0, y: 12), // ending point
            control1: CGPoint(x: 2, y: 14),
            control2: CGPoint(x: 0, y: 14))
        // segment 3: line
        path.addLine(to: CGPoint(x: 0, y: 2))
        // *********************
        // ****** Top side *****
        // *********************
        // segment 4: arc
        path.addArc(center: CGPoint(x: 2, y: 2), // center point of circle
                    radius: 2, // this will make it meet our path line
                    startAngle: Angle(degrees: 180), // π radians = 180 degrees = straight left
                    endAngle: Angle(degrees: 270), // 3π/2 radians = 270 degrees = straight up
                    clockwise: false) // startAngle to endAngle goes in a clockwise direction
        // segment 5: line
        path.addLine(to: CGPoint(x: 8, y: 0))
        // segment 6: arc
        path.addArc(center: CGPoint(x: 8, y: 2),
                    radius: 2,
                    startAngle: Angle(degrees: 90), // straight up
                    endAngle: Angle(degrees: 0), // 0 radians = straight right
            clockwise: false)
        // *********************
        // ***** Right side ****
        // *********************
        // segment 7: line
        path.addLine(to: CGPoint(x: 10, y: 12))
        // segment 8: curve
        path.addCurve(to: CGPoint(x: 8, y: 15), // ending point
            control1: CGPoint(x: 10, y: 14),
            control2: CGPoint(x: 8, y: 14))
        // segment 9: line
        path.addLine(to: CGPoint(x: 8, y: 26))
        // *********************
        // **** Bottom side ****
        // *********************
        // segment 10: line
        path.closeSubpath() // draws the final line to close the path
        return path
    }
    
    func createExampleBezierPath(in rect: CGRect) -> Path {
        // create a new path
        var path = Path()
        // starting point for the path (bottom left)
        let left = rect.origin.x
        let top = rect.origin.y
        let width = rect.width
        let height = rect.height
        let right = left + width
        let bottom = top + height
        
        let inset = width / 5
        let waistY = top + (height*15/26)
        let hipY = top + (height*12/26)
        let controlY = top + (height*14/26)
        let curveRadius = height/13
        let curveCenter1Y = top + curveRadius
        let curveCenter1X = left + curveRadius
        let curveCenter2X = right - curveRadius
        
        let insetLeft = left + inset
        let insetRight = right - inset

        path.move(to: CGPoint(x: insetLeft, y: bottom))
        // *********************
        // ***** Left side *****
        // *********************
        // segment 1: line
                  
        path.addLine(to: CGPoint(x: insetLeft, y: waistY))
        // segment 2: curve
        
        path.addCurve(to: CGPoint(x: left, y: hipY), // ending point
            control1: CGPoint(x: insetLeft, y: controlY),
            control2: CGPoint(x: left, y: controlY))
        // segment 3: line
        path.addLine(to: CGPoint(x: left, y: curveCenter1Y))
        // *********************
        // ****** Top side *****
        // *********************
        // segment 4: arc
        path.addArc(center: CGPoint(x: curveCenter1X, y: curveCenter1Y), // center point of circle
                    radius: curveRadius, // this will make it meet our path line
                    startAngle: Angle(degrees: 180), // π radians = 180 degrees = straight left
                    endAngle: Angle(degrees: 270), // 3π/2 radians = 270 degrees = straight up
                    clockwise: false) // startAngle to endAngle goes in a clockwise direction
        // segment 5: line
        path.addLine(to: CGPoint(x: curveCenter2X, y: top))
        // segment 6: arc
        path.addArc(center: CGPoint(x: curveCenter2X, y: curveCenter1Y),
                    radius: curveRadius,
                    startAngle: Angle(degrees: 90), // straight up
                    endAngle: Angle(degrees: 0), // 0 radians = straight right
                    clockwise: false)
        // *********************
        // ***** Right side ****
        // *********************
        // segment 7: line
        path.addLine(to: CGPoint(x: right, y: hipY))
        // segment 8: curve
        path.addCurve(to: CGPoint(x: insetRight, y: waistY), // ending point
            control1: CGPoint(x: right, y: controlY),
            control2: CGPoint(x: insetRight, y: controlY))
        // segment 9: line
        path.addLine(to: CGPoint(x: insetRight, y: bottom))
//        // *********************
//        // **** Bottom side ****
//        // *********************
        // segment 10: line
        path.closeSubpath() // draws the final line to close the path
        return path
    }
    
    struct SquiggleConstants {
        // Because the original squiggle was drawn in a 60x20 rectangle, all inset calculations are
        // based on that original grid, but then scaled by the original dimensions to fit any
        // rectangle.
        static let defaultWidth = 60.0
        static let defaultHeight = 20.0
        
        // points 0 and 2 are close to the left and right edges, respectively
        static let outmostPointXInset = 1.0
        static let point0XFactor = outmostPointXInset / defaultWidth
        static let point2XFactor = (defaultWidth - outmostPointXInset) / defaultWidth
        
        // points 1 and 3 are slightly farther from the right and left edges, respectively
        static let secondPointXInset = 4.0
        static let point1XFactor = (defaultWidth - secondPointXInset) / defaultWidth
        static let point3XFactor = secondPointXInset / defaultWidth
        
        // points 1 and 3 are close to the top and bottom, respectively
        static let outmostPointYInset = 2.0
        static let point1YFactor = outmostPointYInset / defaultHeight
        static let point3YFactor = (defaultHeight - outmostPointYInset) / defaultHeight
        
        // points 0 and 2 are slightly farther from the bottom and top, respectively
        static let secondPointYInset = 4.0
        static let point0YFactor = (defaultHeight - secondPointYInset) / defaultHeight
        static let point2YFactor = secondPointYInset / defaultHeight
        
        // control points for the high hump of the upper curve, and the low dip of the lower
        // curve, are equal distance away from the left and right edges, respectively
        static let innerControlXInset = 20.0
        static let upperControl1XFactor = innerControlXInset / defaultWidth
        static let lowerControl1XFactor = (defaultWidth - innerControlXInset) / defaultWidth
        
        // control points for the low dip of the upper curve, and the high hump of the lower
        // curve, are equal distances away from the right and left edges, respectively
        static let outerControlXInset = 19.0
        static let upperControl2XFactor = (defaultWidth - outerControlXInset) / defaultWidth
        static let lowerControl2XFactor = outerControlXInset / defaultWidth
        
        // control points for the high hump of the upper curve, and the low dip of the lower
        // curve, are equal distances above and below the top and bottom edges, respectively
        static let outerControlYInset = -29.0
        static let upperControl1YFactor = outerControlYInset / defaultHeight
        static let lowerControl1YFactor = (defaultHeight - outerControlYInset) / defaultHeight
        
        // control points for the low dip of the upper curve, and the high hump of the lower
        // curve, are equal distances below and above the bottom and top edges, respectively
        static let innerControlYInset = -24.0
        static let upperControl2YFactor = (defaultHeight - innerControlYInset) / defaultHeight
        static let lowerControl2YFactor = innerControlYInset / defaultHeight
        
        // control points for the inner parts of the left and right endcaps are the same distance
        // from the left and right edges, respectively
        static let innerEndCapYInset = 3.0
        static let leftCapControl1XFactor = innerEndCapYInset / defaultWidth
        static let rightCapControl1XFactor = (defaultWidth - innerEndCapYInset) / defaultWidth
        
        // control points for the outer parts of the right and left endcaps are the same distance
        // outside the right and left edges, respectively
        static let outerEndCapXInset = -1.0
        static let rightCapControl2XFactor = (defaultWidth - outerEndCapXInset) / defaultWidth
        static let leftCapControl2XFactor = outerEndCapXInset / defaultWidth

        // control points for the highest and lowest parts of the right and left endcaps, respectively
        // are the same distance above and below the top and bottom edges, respectively
        static let fartherEndCapYInset = -1.0
        static let rightCapControl1YFactor = fartherEndCapYInset / defaultHeight
        static let leftCapControl1YFactor = (defaultHeight - fartherEndCapYInset) / defaultHeight
        
        // control points for the closer parts of the right and left endcaps are the same distance
        // inside the top and bottom edges, respectively
        static let closerEndCapYInset = 0.5
        static let rightCapControl2YFactor = closerEndCapYInset / defaultHeight
        static let leftCapControl2YFactor = (defaultHeight - closerEndCapYInset) / defaultHeight
    }
    
    /// Creates and returns an array of the four CGPoints delimiting the four segments of the squiggle, scaled to
    /// fit inside the given CGRect
    /// - Parameter rect: a CGRect circumscribing the squiggle.
    /// - Returns: an Array of four CGPoints
    private func pointsScaled(to rect: CGRect) -> [CGPoint] {
        let top = rect.origin.y
        let height = rect.height
        let width = rect.width
        let left = rect.origin.x
        
        var answer: [CGPoint] = []
        
        let point0x = left + (width * SquiggleConstants.point0XFactor)
        let point0y = top + (height * SquiggleConstants.point0YFactor)
        answer.append(CGPoint(x: point0x, y: point0y))
        
        let point1x = left + (width * SquiggleConstants.point1XFactor)
        let point1y = top + (height * SquiggleConstants.point1YFactor)
        answer.append(CGPoint(x: point1x, y: point1y))

        let point2x = left + (width * SquiggleConstants.point2XFactor)
        let point2y = top + (height * SquiggleConstants.point2YFactor)
        answer.append(CGPoint(x: point2x, y: point2y))

        let point3x = left + (width * SquiggleConstants.point3XFactor)
        let point3y = top + (height * SquiggleConstants.point3YFactor)
        answer.append(CGPoint(x: point3x, y: point3y))

        return answer
    }
    
    /// Creates and returns a Dictionary of Arrays of CGPoints, where each CGPoint controls some aspect
    /// of a curved segment of the squiggle. Each array is a 2-item array with the first and second control points
    /// for its segment. The four segments are "upper," "right," "lower," and "left." The points are all scaled
    /// to fit inside the given rectangle.
    /// - Parameter rect: aCGRect circumscribing the squiggle
    /// - Returns: a Dictionary with four keys, and a 2-item array at each key. where each item in the array
    /// is a CGPoint
    private func controlPointsScaled(to rect: CGRect) -> [String: [CGPoint]] {
        let top = rect.origin.y
        let height = rect.height
        let width = rect.width
        let left = rect.origin.x
        
        var answer: [String: [CGPoint]] = [:]

        let upperControl1x = left + (width * SquiggleConstants.upperControl1XFactor)
        let upperControl1y = top + (height * SquiggleConstants.upperControl1YFactor)
        
        let upperControl2x = left + (width * SquiggleConstants.upperControl2XFactor)
        let upperControl2y = top + (height * SquiggleConstants.upperControl2YFactor)
        
        answer["upper"] = [
            CGPoint(x: upperControl1x, y: upperControl1y),
            CGPoint(x: upperControl2x, y: upperControl2y)
        ]
        
        let rightControl1x = left + (width * SquiggleConstants.rightCapControl1XFactor)
        let rightControl1y = top + (height * SquiggleConstants.rightCapControl1YFactor)
        
        let rightControl2x = left + (width * SquiggleConstants.rightCapControl2XFactor)
        let rightControl2y = top + (height * SquiggleConstants.rightCapControl2YFactor)
        
        answer["right"] = [
            CGPoint(x: rightControl1x, y: rightControl1y),
            CGPoint(x: rightControl2x, y: rightControl2y)
        ]
        
        let lowerControl1x = left + (width * SquiggleConstants.lowerControl1XFactor)
        let lowerControl1y = top + (height * SquiggleConstants.lowerControl1YFactor)
        
        let lowerControl2x = left + (width * SquiggleConstants.lowerControl2XFactor)
        let lowerControl2y = top + (height * SquiggleConstants.lowerControl2YFactor)
        
        answer["lower"] = [
            CGPoint(x: lowerControl1x, y: lowerControl1y),
            CGPoint(x: lowerControl2x, y: lowerControl2y)
        ]
        
        let leftControl1x = left + (width * SquiggleConstants.leftCapControl1XFactor)
        let leftControl1y = top + (height * SquiggleConstants.leftCapControl1YFactor)
        
        let leftControl2x = left + (width * SquiggleConstants.leftCapControl2XFactor)
        let leftControl2y = top + (height * SquiggleConstants.leftCapControl2YFactor)
        
        answer["left"] = [
            CGPoint(x: leftControl1x, y: leftControl1y),
            CGPoint(x: leftControl2x, y: leftControl2y)
        ]
        
        return answer
    }
    
    /// Creates and returns a Path that draws a single squiggle
    /// - Parameter rect: a CGRect circumscribing the squiggle
    /// - Returns: a Path that draws the squiggle
    private func squiggle(in rect: CGRect) -> Path {
        let points = pointsScaled(to: rect)
        let controlPoints = controlPointsScaled(to: rect)
    
        var path = Path()

        path.move(to: points[0])
        path.addCurve(to: points[1],
                      control1: controlPoints["upper"]![0],
                      control2: controlPoints["upper"]![1])
        
        path.addCurve(to: points[2],
                      control1: controlPoints["right"]![0],
                      control2: controlPoints["right"]![1])

        path.addCurve(to: points[3],
                      control1: controlPoints["lower"]![0],
                      control2: controlPoints["lower"]![1])
        
        path.addCurve(to: points[0],
                      control1: controlPoints["left"]![0],
                      control2: controlPoints["left"]![1])

        return path
    }
    
    /// For debugging, creates and returns a Path that shows the point at the beginning of the first (iupper) segment,
    /// as well as the control points for the upper segment
    /// - Parameter rect: a CGRect circumscribing the squiggle
    /// - Returns: a Path that draws the three points
    func points0to1Path(in rect: CGRect) -> Path {
        let point = pointsScaled(to: rect)[0]
        let controlPoints = controlPointsScaled(to: rect)
        
        let radius = 4.0
        
        var path = Path()
        path.move(to: point)
        path.addArc(center: point,
                    radius: radius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: false)
        path.move(to: controlPoints["upper"]![0])
        path.addArc(center: controlPoints["upper"]![0],
                    radius: radius/2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        path.move(to: controlPoints["upper"]![1])
        path.addArc(center: controlPoints["upper"]![1],
                    radius: radius / 2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        
        return path
    }
    
    /// For debugging, creates and returns a Path that shows the point at the beginning of the second (right) segment,
    /// as well as the control points for the right segment
    /// - Parameter rect: a CGRect circumscribing the squiggle
    /// - Returns: a Path that draws the three points
    func points1to2Path(in rect: CGRect) -> Path {
        let point = pointsScaled(to: rect)[1]
        let controlPoints = controlPointsScaled(to: rect)
        
        let radius = 4.0
        
        var path = Path()
        path.move(to: point)
        path.addArc(center: point,
                    radius: radius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: false)
        path.move(to: controlPoints["right"]![0])
        path.addArc(center: controlPoints["right"]![0],
                    radius: radius/2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        path.move(to: controlPoints["right"]![1])
        path.addArc(center: controlPoints["right"]![1],
                    radius: radius / 2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        
        return path
    }
    
    /// For debugging, creates and returns a Path that shows the point at the beginning of the third (lower) segment,
    /// as well as the control points for the lower segment
    /// - Parameter rect: a CGRect circumscribing the squiggle
    /// - Returns: a Path that draws the three points
    func points2to3Path(in rect: CGRect) -> Path {
        let point = pointsScaled(to: rect)[2]
        let controlPoints = controlPointsScaled(to: rect)
        
        let radius = 4.0
        
        var path = Path()
        path.move(to: point)
        path.addArc(center: point,
                    radius: radius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: false)
        path.move(to: controlPoints["lower"]![0])
        path.addArc(center: controlPoints["lower"]![0],
                    radius: radius/2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        path.move(to: controlPoints["lower"]![1])
        path.addArc(center: controlPoints["lower"]![1],
                    radius: radius / 2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        
        return path
    }
    
    /// For debugging, creates and returns a Path that shows the point at the beginning of the last (left) segment,
    /// as well as the control points for the left segment
    /// - Parameter rect: a CGRect circumscribing the squiggle
    /// - Returns: a Path that draws the three points
    func points3to0Path(in rect: CGRect) -> Path {
        let point = pointsScaled(to: rect)[3]
        let controlPoints = controlPointsScaled(to: rect)
                
        let radius = 4.0
        
        var path = Path()
        path.move(to: point)
        path.addArc(center: point,
                    radius: radius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: false)
        path.move(to: controlPoints["left"]![0])
        path.addArc(center: controlPoints["left"]![0],
                    radius: radius/2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        path.move(to: controlPoints["left"]![1])
        path.addArc(center: controlPoints["left"]![1],
                    radius: radius / 2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        
        return path
    }
    
    func path(in rect: CGRect) -> Path {
//        return createBezierPath()
//        return createBezierPath(in: rect)
        
        return squiggle(in: rect)
    }
}

struct SquiggleView: View {
    let debugging = false
    var body: some View {
        ZStack {
            let rect = CGRect(x:0, y: 100, width: 350, height: 100)
            Rectangle()
                .path(in: rect)
                .opacity(0.1)

            SquiggleShape()
                .path(in: rect)
                .strokedPath(StrokeStyle())
            
            if debugging {
                SquiggleShape()
                    .points0to1Path(in: rect)
                    .foregroundColor(.red)
                    .opacity(0.75)
                SquiggleShape()
                    .points1to2Path(in: rect)
                    .foregroundColor(.purple)
                    .opacity(0.75)
                SquiggleShape()
                    .points2to3Path(in: rect)
                    .foregroundColor(.green)
                    .opacity(0.75)
                SquiggleShape()
                    .points3to0Path(in: rect)
                    .foregroundColor(.blue)
                    .opacity(0.75)
            }

        }
        .padding()
    }
}

struct SquiggleShape_Previews: PreviewProvider {
    static var previews: some View {
        SquiggleView()
    }
}
