//
//  GridCell.swift
//  Emojii Generator
//
//  Created by Kartavya Sharma on 5/1/23.
//

import Foundation
import SwiftUI

struct GridCell: View {
    @Binding var character: String
    
    var body: some View {
        Text(character)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .border(Color.black, width: 1)
    }
}
