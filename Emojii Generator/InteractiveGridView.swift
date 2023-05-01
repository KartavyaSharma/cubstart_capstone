//
//  InteractiveGridView.swift
//  Emojii Generator
//
//  Created by Kartavya Sharma on 5/1/23.
//

import Foundation
import SwiftUI

struct DragAndDropGridView: View {
    @State private var inputText: String = ""
    @State private var items: [[String]] = Array(repeating: Array(repeating: "", count: 6), count: 4)

    var body: some View {
        VStack {
            TextField("Enter text here...", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            GridView(items: $items)
                .overlay(
                    GeometryReader { geometry in
                        ZStack {
                            ForEach(0..<items.count, id: \.self) { row in
                                ForEach(0..<items[row].count, id: \.self) { column in
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.clear)
                                        .frame(width: 60, height: 60)
                                        .padding(4)
                                        .offset(x: CGFloat(column) * 64, y: CGFloat(row) * 64)
                                        .onDrag {
                                            guard !inputText.isEmpty else { return nil }
                                            let provider = NSItemProvider(object: inputText as NSString)
                                            provider.previewImageHandler = { _, _ in
                                                UIGraphicsImageRenderer(size: CGSize(width: 60, height: 60)).image { _ in
                                                    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
                                                    label.text = inputText
                                                    label.font = UIFont.boldSystemFont(ofSize: 17)
                                                    label.textAlignment = .center
                                                    label.textColor = .black
                                                    label.drawHierarchy(in: label.bounds, afterScreenUpdates: true)
                                                }
                                            }
                                            return provider
                                        }
                                        .onDrop(of: [.text], delegate: DropDelegate(inputText: $inputText, items: $items, row: row, column: column))
                                }
                            }
                        }
                    }
                )
        }
    }
}

struct DropDelegate: DropDelegate {
    @Binding var inputText: String
    @Binding var items: [[String]]
    let row: Int
    let column: Int

    func performDrop(info: DropInfo) -> Bool {
        guard info.hasItemsConforming(to: [.text]) else { return false }

        info.loadObjects(ofType: String.self) { textItems in
            if let text = textItems.first {
                items[row][column] = text
                inputText = ""
            }
        }

        return true
    }
}
