//
//  SegmentedShape.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 12/8/22.
//

import SwiftUI

protocol SegmentedShape: Shape {
    var segments: [any Segment] {get}
}

extension SegmentedShape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard segments.count > 0 else {return path}
        
        let scaledSegments = segmentsScaled(to: rect.size)

        path.move(to: segments.first!.startPoint)
        
        scaledSegments.forEach {segment in
            path.addLine(to: segment.endPoint)
        }
        return path
    }
    
    private func segmentsScaled(to size: CGSize) -> [any Segment] {
        segments.map{$0.scaled(to: size)}
    }
}
