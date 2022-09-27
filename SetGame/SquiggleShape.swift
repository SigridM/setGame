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
    
    let p0xf = 1.0/60.0
    let p0yf = 16.0/20.0

    let p1xf = 56.0/60.0
    let p1yf = 2.0/20.0
    
    let p2xf = 59.0/60.0
    let p2yf = 4.0/20.0
    
    let p3xf = 4.0/60.0
    let p3yf = 18.0/20.0
    
    let c1_1xf = 20.0/60.0
    let c1_1yf = -29.0/20.0
    
    let c1_2xf = 40.0/60.0
    let c1_2yf = 44.0/20.0

    let c3_1xf = 39.0/60.0
    let c3_1yf = 49.0/20.0

    let c3_2xf = 19.0/60.0
    let c3_2yf = -24.0/20.0
    
    let c2_1xf = 57.0/60.0
    let c2_1yf = -1.0/20.0
    
    let c2_2xf = 61.0/60.0
    let c2_2yf = 0.5/20.0
    
    let c4_1xf = 3.0/60.0
    let c4_1yf = 21.0/20.0
    
    let c4_2xf = -1.0/60.0
    let c4_2yf = 19.5/20.0
        
    func squiggle(in rect: CGRect) -> Path {
        let top = rect.origin.y
        let height = rect.height
        let width = rect.width
        let left = rect.origin.x
        
        let point0x = left + (width * p0xf)
        let point0y = top + (height * p0yf)
        
        let control1_1x = left + (width * c1_1xf)
        let control1_1y = top + (height * c1_1yf)
        
        let control1_2x = left + (width * c1_2xf)
        let control1_2y = top + (height * c1_2yf)
        
        let point1x = left + (width * p1xf)
        let point1y = top + (height * p1yf)
        
        let control2_1x = left + (width * c2_1xf)
        let control2_1y = top + (height * c2_1yf)
        
        let control2_2x = left + (width * c2_2xf)
        let control2_2y = top + (height * c2_2yf)
        
        let point2x = left + (width * p2xf)
        let point2y = top + (height * p2yf)

        let control3_1x = left + (width * c3_1xf)
        let control3_1y = top + (height * c3_1yf)
        
        let control3_2x = left + (width * c3_2xf)
        let control3_2y = top + (height * c3_2yf)
        
        let point3x = left + (width * p3xf)
        let point3y = top + (height * p3yf)
        
        let control4_1x = left + (width * c4_1xf)
        let control4_1y = top + (height * c4_1yf)
        
        let control4_2x = left + (width * c4_2xf)
        let control4_2y = top + (height * c4_2yf)
       
        var path = Path()

        path.move(to: CGPoint(x:point0x, y: point0y))
        path.addCurve(to: CGPoint(x: point1x, y: point1y), // ending point
                      control1: CGPoint(x: control1_1x, y: control1_1y),
                      control2: CGPoint(x: control1_2x, y: control1_2y))
        
        path.addCurve(to: CGPoint(x: point2x, y: point2y), control1: CGPoint(x: control2_1x, y: control2_1y), control2: CGPoint(x: control2_2x, y: control2_2y))

        path.addCurve(to: CGPoint(x: point3x, y: point3y), // ending point
                      control1: CGPoint(x: control3_1x, y: control3_1y),
                      control2: CGPoint(x: control3_2x, y: control3_2y))
        
        path.addCurve(to: CGPoint(x: point0x, y: point0y), // ending point
                      control1: CGPoint(x: control4_1x, y: control4_1y),
                      control2: CGPoint(x: control4_2x, y: control4_2y))

        return path
    }
    func points0to1Path(in rect: CGRect) -> Path {
        let top = rect.origin.y
        let height = rect.height
        let width = rect.width
        let left = rect.origin.x
        
        let point0x = left + (width * p0xf)
        let point0y = top + (height * p0yf)
        
        let control1_1x = left + (width * c1_1xf)
        let control1_1y = top + (height * c1_1yf)
        
        let control1_2x = left + (width * c1_2xf)
        let control1_2y = top + (height * c1_2yf)
        
        let radius = 4.0
        
        var path = Path()
        path.move(to: CGPoint(x:point0x, y: point0y))
        path.addArc(center: CGPoint(x:point0x, y: point0y),
                    radius: radius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: false)
        path.move(to: CGPoint(x:control1_1x, y: control1_1y))
        path.addArc(center: CGPoint(x:control1_1x, y: control1_1y),
                    radius: radius/2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        path.move(to: CGPoint(x:control1_2x, y: control1_2y))
        path.addArc(center: CGPoint(x:control1_2x, y: control1_2y),
                    radius: radius / 2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        
        return path
    }
    
    func points1to2Path(in rect: CGRect) -> Path {
        let top = rect.origin.y
        let height = rect.height
        let width = rect.width
        let left = rect.origin.x
        
        let point1x = left + (width * p1xf)
        let point1y = top + (height * p1yf)
        
        let control2_1x = left + (width * c2_1xf)
        let control2_1y = top + (height * c2_1yf)
        
        let control2_2x = left + (width * c2_2xf)
        let control2_2y = top + (height * c2_2yf)
        
        let radius = 4.0
        
        var path = Path()
        path.move(to: CGPoint(x:point1x, y: point1y))
        path.addArc(center: CGPoint(x:point1x, y: point1y),
                    radius: radius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: false)
        path.move(to: CGPoint(x:control2_1x, y: control2_1y))
        path.addArc(center: CGPoint(x:control2_1x, y: control2_1y),
                    radius: radius/2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        path.move(to: CGPoint(x:control2_2x, y: control2_2y))
        path.addArc(center: CGPoint(x:control2_2x, y: control2_2y),
                    radius: radius / 2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        
        return path
    }
    
    func points2to3Path(in rect: CGRect) -> Path {
        let top = rect.origin.y
        let height = rect.height
        let width = rect.width
        let left = rect.origin.x
        
        let point2x = left + (width * p2xf)
        let point2y = top + (height * p2yf)

        let control3_1x = left + (width * c3_1xf)
        let control3_1y = top + (height * c3_1yf)
        
        let control3_2x = left + (width * c3_2xf)
        let control3_2y = top + (height * c3_2yf)
        
        let radius = 4.0
        
        var path = Path()
        path.move(to: CGPoint(x:point2x, y: point2y))
        path.addArc(center: CGPoint(x:point2x, y: point2y),
                    radius: radius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: false)
        path.move(to: CGPoint(x:control3_1x, y: control3_1y))
        path.addArc(center: CGPoint(x:control3_1x, y: control3_1y),
                    radius: radius/2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        path.move(to: CGPoint(x:control3_2x, y: control3_2y))
        path.addArc(center: CGPoint(x:control3_2x, y: control3_2y),
                    radius: radius / 2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        
        return path
    }
    
    func points3to4Path(in rect: CGRect) -> Path {
        let top = rect.origin.y
        let height = rect.height
        let width = rect.width
        let left = rect.origin.x
        
        let point3x = left + (width * p3xf)
        let point3y = top + (height * p3yf)
        
        let control4_1x = left + (width * c4_1xf)
        let control4_1y = top + (height * c4_1yf)
        
        let control4_2x = left + (width * c4_2xf)
        let control4_2y = top + (height * c4_2yf)
        
        let radius = 4.0
        
        var path = Path()
        path.move(to: CGPoint(x:point3x, y: point3y))
        path.addArc(center: CGPoint(x:point3x, y: point3y),
                    radius: radius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: false)
        path.move(to: CGPoint(x:control4_1x, y: control4_1y))
        path.addArc(center: CGPoint(x:control4_1x, y: control4_1y),
                    radius: radius/2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        path.move(to: CGPoint(x:control4_2x, y: control4_2y))
        path.addArc(center: CGPoint(x:control4_2x, y: control4_2y),
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
            let rect = CGRect(x:0, y: 100, width: 300, height: 100)
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
                    .opacity(0.5)
                SquiggleShape()
                    .points1to2Path(in: rect)
                    .foregroundColor(.orange)
                    .opacity(0.5)
                SquiggleShape()
                    .points2to3Path(in: rect)
                    .foregroundColor(.green)
                SquiggleShape()
                    .points3to4Path(in: rect)
                    .foregroundColor(.blue)
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
