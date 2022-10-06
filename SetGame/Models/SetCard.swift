//
//  SetCard.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 10/6/22.
//

import Foundation

struct SetCard: Equatable {
    let shape: ShapeFeature
    let shading: ShadeFeature
    let color: ColorFeature
    let number: NumberFeature
    
    var isSelected = false
    
    func formsSetWith(_ secondCard: SetCard, and thirdCard: SetCard) -> Bool {
        self.shape.formsSetWith(secondCard.shape, and: thirdCard.shape) &&
        self.shading.formsSetWith(secondCard.shading, and: thirdCard.shading) &&
        self.color.formsSetWith(secondCard.color, and: thirdCard.color) &&
        self.number.formsSetWith(secondCard.number, and: thirdCard.number)
    }
    
    mutating func toggleSelection() {
        isSelected = !isSelected
    }
    
    var id: Int {
        return shape.rawValue * 1000
        + shading.rawValue * 100
        + color.rawValue * 10
        + number.rawValue
    }
}
