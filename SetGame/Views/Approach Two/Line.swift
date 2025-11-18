//
//  Line.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 12/7/22.
//

import SwiftUI


struct Line: Segment {
    var startPoint = CGPoint(x: 0, y: 0)
    
    var endPoint = CGPoint(x: 0, y: 0)
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        self.add(to: &path)
        return path
    }
}
