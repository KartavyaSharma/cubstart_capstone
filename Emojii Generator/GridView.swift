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
    @State private var predefinedCharacter: String = " "
    @State private var currentCharacter: String = " "
    
    @State private var gridCharacters: [[String]] = Array(repeating: Array(repeating: " ", count: 5), count: 5)//backend.init(filename : nil)
    /* let rows : Int = gridCharacters.count
    let columns : Int = gridCharacters[0].count*/
    @State private var currentPosition: CGPoint = .zero
    
    @State private var erasing : Bool = false
    
    
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
        VStack{
            Spacer()
            HStack{
                TextField(
                    "enter your character",
                    text: $currentCharacter
                )
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.secondary)
                .onSubmit {
                    predefinedCharacter = currentCharacter
                    erasing = false
                }
                .font(.title)
                .frame(width: 250, height: 40)
                .foregroundColor(Color.black)
                .background(Color(UIColor(red: CGFloat(0xF3) / 255, green: CGFloat(0xE1) / 255, blue: CGFloat(0xA0) / 255, alpha: 1)))
                Button("erase"){
                   erasing = erasing ? false : true
                   predefinedCharacter = erasing ? " " : currentCharacter
                }
                .font(.title)
                .frame(width: 100, height: 40)
                .foregroundColor(Color.black)
                .background(Color(erasing ? .blue : .gray))
            }
            Text(String(predefinedCharacter))
                .font(.title2)
            /*
             Button()
             */
            
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
        .background(Color(UIColor(red: CGFloat(0xf3) / 255, green: CGFloat(0xe1) / 255, blue: CGFloat(0xa1) / 255, alpha: 0.625)))
    }
}
