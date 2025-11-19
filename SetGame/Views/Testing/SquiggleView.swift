//
//  SquiggleView.swift
//  SetGame
//
//  Created by Sigrid Mortensen on 12/16/22.
//

import SwiftUI

struct SquiggleView: View {
    let debugging = false // Toggle to false to hide debug overlays
    let color: Color = .blue
    @State private var squiggleDirection = 1.0
    @State private var animating = false

    var body: some View {
        VStack {
            GeometryReader { geometry in
                let rowHeight = geometry.size.height / 3
                VStack(spacing: 0) {
                    SquiggleRow(repetitions: 1, direction: squiggleDirection * -1.0, color: color, debugging: debugging, animating: animating)
                        .frame(height: rowHeight)
                        .padding(.vertical, 4)
                    SquiggleRow(repetitions: 2, direction: squiggleDirection, color: color, debugging: debugging, animating: animating)
                        .frame(height: rowHeight)
                        .padding(.vertical, 4)
                    SquiggleRow(repetitions: 3, direction: squiggleDirection, color: color, debugging: debugging, animating: animating)
                        .frame(height: rowHeight)
                        .padding(.vertical, 4)
                }
                .clipped()
            }
            .padding()
            Button("Toggle Animation") {
                animating.toggle()
            }
            .padding()
        }
        .background(Color.white)
    }
}

private struct SquiggleRow: View {
    let repetitions: Int
    let direction: Double
    let color: Color
    let debugging: Bool
    let animating: Bool

    var body: some View {
        GeometryReader { rowGeo in
            ZStack {
                if debugging {
                    Rectangle()
                        .fill(Color.gray.opacity(0.07))
                        .frame(width: rowGeo.size.width, height: rowGeo.size.height)
                        .clipped()
                        .zIndex(0)
                    Rectangle()
                        .strokeBorder(Color.black.opacity(0.3), lineWidth: 1)
                        .frame(width: rowGeo.size.width, height: rowGeo.size.height)
                        .zIndex(0)
                }

                Group {
                    if animating {
                        SquiggleShape(repetitions: repetitions, direction: direction)
                            .stroke(style: StrokeStyle(lineWidth: 3.0))
                            .foregroundColor(color)
                            .frame(width: rowGeo.size.width, height: rowGeo.size.height, alignment: .center)
                            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: animating)
                    } else {
                        SquiggleShape(repetitions: repetitions, direction: direction)
                            .stroke(style: StrokeStyle(lineWidth: 3.0))
                            .foregroundColor(color)
                            .frame(width: rowGeo.size.width, height: rowGeo.size.height, alignment: .center)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .zIndex(1)

                if debugging {
                    SquiggleShape(repetitions: repetitions, direction: direction)
                        .debugViews(in: CGRect(origin: .zero, size: rowGeo.size), with: [.red.opacity(0.2), .green.opacity(0.2), .cyan.opacity(0.2), .yellow.opacity(0.2)])
                        .frame(width: rowGeo.size.width * 0.9, height: rowGeo.size.height * 0.9)
                        .opacity(0.15)
                        .zIndex(0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

#Preview {
    SquiggleView()
}
