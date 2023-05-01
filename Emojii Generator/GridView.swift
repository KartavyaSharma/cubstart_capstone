//
//  GridView.swift
//  Emojii Generator
//
//  Created by Kartavya Sharma on 5/1/23.
//

import SwiftUI

struct GridView: View {
    let columns: Int = 5
    let rows: Int = 5
    let predefinedCharacter: Character = "X"
    
    @State private var gridCharacters: [[Character]] = Array(repeating: Array(repeating: " ", count: 5), count: 5)
    @State private var currentPosition: CGPoint = .zero
    
    private func indexForLocation(_ location: CGPoint, gridSize: CGSize) -> (Int, Int)? {
        let cellWidth = gridSize.width / CGFloat(columns)
        let cellHeight = gridSize.height / CGFloat(rows)
        
        let column = Int(location.x / cellWidth)
        let row = Int(location.y / cellHeight)
        
        guard column >= 0 && column < columns && row >= 0 && row < rows else {
            return nil
        }
        
        return (column, row)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<columns, id: \.self) { column in
                            GridCell(character: $gridCharacters[row][column])
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if let (column, row) = indexForLocation(value.location, gridSize: geometry.size) {
                            gridCharacters[row][column] = predefinedCharacter
                        }
                    }
            )
        }
    }
}
