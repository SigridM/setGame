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
    public func noneSatisfy(_ passesTest: (Element)-> Bool) -> Bool {
        for x in self {
            if passesTest(x) {
                return false // at least one satisfies the test
            }
        }
        return true // got all the way through and none satisfied the test
    }
    
    /// Looks through the array to ascertain whether at least one element passes the given test
    /// - Parameter test: a closure taking one element and returning a Boolean: true if that element passes the test
    /// - Returns: a Boolean: true if at least one element passes the test; false if all elements fail the test.
    public func anySatisfy(_ passesTest: (Element)-> Bool) -> Bool {
        for x in self {
            if passesTest(x) {
                return true // at least one satisfies the test
            }
        }
        return false // got all the way through and none satisfied the test
    }
    
    /// Returns the single element in the Array, if there is only one element. If there are more or zero elements; returns nil.
    public var oneAndOnly: Element? {
        if count == 1 {return first}
        return nil
    }
    
    /// Removes the top k elements from the Array and returns them in a new Array. If there are fewer than k elements in
    /// the receiver, it returns as many as it can, which may be zero (an empty Array).
    /// - Parameter k: the number of elements to pop
    /// - Returns: an Array of  up to k elements from the original Array, or an Array containing all of the elements in the
    /// original Array, if there are less than k elements.
    public mutating func popLast(_ k: Int) -> [Element] {
        var answer: [Element] = []
        let upperLimit = Swift.min(k, self.count)
        for _ in 0..<upperLimit {
            answer.prepend(self.popLast()!)
        }
        return answer
    }
    
    /// Add an element to the Array, but add it at the beginning, not at the end like append() does.
    /// - Parameter element: the Element to add at the beginning of the Array
    public mutating func prepend(_ element: Element) {
        insert(element, at: 0)
    }
    
    /// Answers an Array of Ints that are the indices into the Array where the given test on an element at that index succeeds
    /// - Parameter passesTest: a Closure testing a given element and returning a Boolean for whether to include the
    /// index of that element in the answer.
    /// - Returns: an Array of Ints where each Int is an index into the original Array where the given test succeeds.
    public func indices(where passesTest: (Element) -> Bool) -> [Int] {
        var answer: [Int] = []
        for index in self.indices {
            if passesTest(self[index]) {
                answer.append(index)
            }
        }
        return answer
    }
    
    /// Removes the top k elements from the Array and returns them in a new Array. If there are fewer than k elements in
    /// the receiver, it returns as many as it can, which may be zero (an empty Array).
    /// - Parameter k: the number of elements to pop
    /// - Returns: an Array of  up to k elements from the original Array, or an Array containing all of the elements in the
    /// original Array, if there are less than k elements.
    public mutating func removeFirst(_ k: Int) -> [Element] {
        var answer: [Element] = []
        let upperLimit = Swift.min(k, self.count)
        for _ in 0..<upperLimit {
            answer.append(self.removeFirst())
        }
        return answer
    }
}

extension CGPoint {
    /// Answers a new CGPoint that is displaced from the position of the original CGPoint by the given distance
    /// - Parameter distance: a CGPoint for how far the new point should be shifted from the original
    /// - Returns: a new CGPoint, shifted by distance from the location of the original CGPoint
    public func moved(by distance: CGPoint) -> CGPoint {
        let translation = CGAffineTransform(translationX: distance.x, y: distance.y)
        return self.applying(translation)
    }
    
    /// Answers a new CGPoint that is scaled from the size of the original CGPoint by the given size
    /// - Parameter size: a CGSize for how much the new point should be scaled relative to the original
    /// - Returns: a new CGPoint, scaled by size from the original CGPoint
    public func scaled(to size: CGSize) -> CGPoint {
        let scaling = CGAffineTransform(scaleX: size.width, y: size.height)
        return self.applying(scaling)
    }
}

extension CGRect {
    /// A computed CGFloat that is the left-hand side of the rectangle within its coordinate space
    public var left: CGFloat {
        return origin.x
    }
    /// A computed CGFloat that is the top of the rectangle within its coordinate space
    public var top: CGFloat {
        return origin.y
    }
    
    /// A computed CGPoint that is the bottom-right corner of the rectangle within its coordinate space
    public var corner: CGPoint {
        return origin.moved(by: CGPoint(x: size.width, y: size.height))
    }
    /// A computed CGFloat that is the right-hand side of the rectangle within its coordinate space
    public var right: CGFloat {
        return corner.x
    }
    
    /// A computed CGFloat that is the bottom of the rectangle within its coordinate space
    public var bottom: CGFloat {
        return corner.y
    }
    
    /// A computed CGPoint that is the center of the rectangle within its coordinate space
    public var center: CGPoint {
        return origin.moved(by: CGPoint(x: size.width/2, y: size.height/2))
    }
}

extension CGFloat {
    /// A convenience function for creating a CGSize from a CGFloat, where the receiver is the width, e.g.:
    /// 10.0.by(20.0)
    /// - Parameter height: a CGFloat that is the height dimension of the size
    /// - Returns: a CGSize with the receiver as the width and the parameter as the height
    public func by(_ height: CGFloat) -> CGSize {
        return CGSize(width: self, height: height)
    }
    
    /// A convenience operator for creating a CGPoint from two CGFloats, e.g.,
    /// 10.0 ＠ 20.0
    /// - Parameters:
    ///   - lhs: the CGFloat that is the x value of the CGPoint
    ///   - rhs: the CGFloat that is the y value of the CGPoint
    /// - Returns: a CGPoint with the two operands as its x and y values
    public static func ＠(lhs: CGFloat, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs, y: rhs)
    }
}

extension Double {
    /// A convenience function for creating a CGSize from a Double, where the receiver is the width, e.g.:
    /// 10.0.by(20.0)
    /// - Parameter height: a Double that is the height dimension of the size
    /// - Returns: a CGSize with the receiver as the width and the parameter as the height
    public func by(_ y: Double) -> CGSize {
        return CGSize(width: self, height: y)
    }
    
    /// A convenience operator for creating a CGPoint from two Doubles, e.g.,
    /// 10.0 ＠ 20.0
    /// - Parameters:
    ///   - lhs: the Double that is the x value of the CGPoint
    ///   - rhs: the Double that is the y value of the CGPoint
    /// - Returns: a CGPoint with the two operands as its x and y values
    public static func ＠(lhs: Double, rhs: Double) -> CGPoint {
        return CGPoint(x: lhs, y: rhs)
    }
}

extension CGSize {
    /// Subtract the same amount from both the width and height of the CGSize
    /// - Parameters:
    ///   - lhs: the CGSize from which we are subtracting the amount
    ///   - rhs: a Double which will be subtracted from both the width and height
    /// - Returns: a new CGSize that is reduced in both width and height by the rhs Double from the original CGSize
    public static func -(lhs: CGSize, rhs: Double) -> CGSize {
        return CGSize(width: lhs.width - rhs, height: lhs.height - rhs)
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
