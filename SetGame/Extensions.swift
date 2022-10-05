//
//  Extensions.swift
//  Memorize
//
//  Created by Sigrid Mortensen on 9/6/22.
//

import Foundation
import SwiftUI

extension Bool {
    /// Turns a Boolean into an integer: 1 if the receiver is true, and 0 if false
    public var intValue: Int {
        return self ? 1 : 0
    }
}

extension Int {
    /// Turns an integer into a Boolean, false only if the receiver is zero
    public var boolValue: Bool {
        return self != 0
    }
}

extension Array {
    /// Looks through the array to ascertain if no elements pass the given test
    /// - Parameter test: a closure taking one element and returning a Boolean: true if that element passes the test
    /// - Returns: a Boolean: true if no elements pass the test (i.e., if all elements fail the test); false if even one element passes
    public func noneSatisfy(_ test: (Element)-> Bool) -> Bool {
        for x in self {
            if test(x) {
                return false // at least one satisfies the test
            }
        }
        return true // got all the way through and none satisfied the test
    }
    
    /// Looks through the array to ascertain whether at least one element passes the given test
    /// - Parameter test: a closure taking one element and returning a Boolean: true if that element passes the test
    /// - Returns: a Boolean: true if at least one element passes the test; false if all elements fail the test.
    public func anySatisfy(_ test: (Element)-> Bool) -> Bool {
        for x in self {
            if test(x) {
                return true // at least one satisfies the test
            }
        }
        return false // got all the way through and none satisfied the test
    }
    
    public var oneAndOnly: Element? {
        if count == 1 {return first}
        return nil
    }
    
    mutating func popLast(_ k: Int) -> [Element] {
        var answer: [Element] = []
        let upperLimit = Swift.min(k, self.count)
        for _ in 0..<upperLimit {
            answer.append(self.popLast()!)
        }
        return answer
    }
    
    public func indices(where test: (Element) -> Bool) -> [Int] {
        var answer: [Int] = []
        for index in self.indices {
            if test(self[index]) {
                answer.append(index)
            }
        }
        return answer
    }
}

extension CGPoint {
    public func moved(by distance: CGPoint) -> CGPoint {
        let translation = CGAffineTransform(translationX: distance.x, y: distance.y)
        return self.applying(translation)
    }
    
    public func scaled(to size: CGSize) -> CGPoint {
        let scaling = CGAffineTransform(scaleX: size.width, y: size.height)
        return self.applying(scaling)
    }
}

extension CGRect {
    public var left: CGFloat {
        return origin.x
    }
    public var top: CGFloat {
        return origin.y
    }
    public var corner: CGPoint {
        return origin.moved(by: CGPoint(x: size.width, y: size.height))
    }
    public var right: CGFloat {
        return corner.x
    }
    public var bottom: CGFloat {
        return corner.y
    }
    public var center: CGPoint {
        return origin.moved(by: CGPoint(x: size.width/2, y: size.height/2))
    }
}

extension CGFloat {
    public func by(_ y: CGFloat) -> CGSize {
        return CGSize(width: self, height: y)
    }
    
    static func ＠(lhs: CGFloat, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs, y: rhs)
    }
}

extension Double {
    public func by(_ y: CGFloat) -> CGSize {
        return CGSize(width: self, height: y)
    }
    
    static func ＠(lhs: Double, rhs: Double) -> CGPoint {
        return CGPoint(x: lhs, y: rhs)
    }
}

extension UIColor {
    
    /// make a diagonal striped pattern
    func patternStripes(color2: UIColor = .white, barThickness t: CGFloat = 25.0) -> UIColor {
        let dim: CGFloat = t * 2.0 * sqrt(2.0)
        
        let img = UIGraphicsImageRenderer(size: .init(width: dim, height: dim)).image { context in
            
            // rotate the context and shift up
            context.cgContext.rotate(by: CGFloat.pi / 4.0)
            context.cgContext.translateBy(x: 0.0, y: -2.0 * t)
            
            let bars: [(UIColor,UIBezierPath)] = [
                (self,  UIBezierPath(rect: .init(x: 0.0, y: 0.0, width: dim * 2.0, height: t))),
                (color2,UIBezierPath(rect: .init(x: 0.0, y: t, width: dim * 2.0, height: t)))
            ]
            
            bars.forEach {  $0.0.setFill(); $0.1.fill() }
            
            // move down and paint again
            context.cgContext.translateBy(x: 0.0, y: 2.0 * t)
            bars.forEach {  $0.0.setFill(); $0.1.fill() }
        }
        
        return UIColor(patternImage: img)
    }
    
}
